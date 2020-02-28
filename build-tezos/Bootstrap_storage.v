(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Constants_repr.
Require Tezos.Contract_repr.
Require Tezos.Contract_storage.
Require Tezos.Cycle_repr.
Require Tezos.Delegate_storage.
Require Tezos.Misc.
Require Tezos.Parameters_repr.
Require Tezos.Raw_context.
Require Tezos.Script_repr.
Require Tezos.Storage_mli. Module Storage := Storage_mli.
Require Tezos.Storage_sigs.
Require Tezos.Tez_repr.

Import Misc.

Definition init_account
  (ctxt : Raw_context.t)
  (function_parameter : Parameters_repr.bootstrap_account)
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let '{|
    Parameters_repr.bootstrap_account.public_key_hash := public_key_hash;
      Parameters_repr.bootstrap_account.public_key := public_key;
      Parameters_repr.bootstrap_account.amount := amount
      |} := function_parameter in
  let contract := Contract_repr.implicit_contract public_key_hash in
  let=? ctxt := Contract_storage.credit ctxt contract amount in
  match public_key with
  | Some public_key =>
    let=? ctxt :=
      Contract_storage.reveal_manager_key ctxt public_key_hash public_key in
    let=? ctxt := Delegate_storage.set ctxt contract (Some public_key_hash) in
    Error_monad.__return ctxt
  | None => Error_monad.__return ctxt
  end.

Definition init_contract
  (typecheck :
    Raw_context.t -> Script_repr.t ->
    Lwt.t
      (Error_monad.tzresult
        ((Script_repr.t * option Contract_storage.big_map_diff) * Raw_context.t)))
  (ctxt : Raw_context.t)
  (function_parameter : Parameters_repr.bootstrap_contract)
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let '{|
    Parameters_repr.bootstrap_contract.delegate := delegate;
      Parameters_repr.bootstrap_contract.amount := amount;
      Parameters_repr.bootstrap_contract.script := script
      |} := function_parameter in
  let=? '(ctxt, contract) :=
    Contract_storage.fresh_contract_from_current_nonce ctxt in
  let=? '(script, ctxt) := typecheck ctxt script in
  let=? ctxt :=
    Contract_storage.originate_raw ctxt (Some true) contract amount script
      (Some delegate) in
  Error_monad.__return ctxt.

Definition init
  (ctxt : Raw_context.t)
  (typecheck :
    Raw_context.t -> Script_repr.t ->
    Lwt.t
      (Error_monad.tzresult
        ((Script_repr.t * option Contract_storage.big_map_diff) * Raw_context.t)))
  (ramp_up_cycles : option int) (no_reward_cycles : option int)
  (accounts : list Parameters_repr.bootstrap_account)
  (contracts : list Parameters_repr.bootstrap_contract)
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let __nonce_value :=
    (|Operation_hash|).(S.HASH.hash_bytes) None
      [ MBytes.of_string "Un festival de GADT." ] in
  let ctxt := Raw_context.init_origination_nonce ctxt __nonce_value in
  let=? ctxt := Error_monad.fold_left_s init_account ctxt accounts in
  let=? ctxt := Error_monad.fold_left_s (init_contract typecheck) ctxt contracts
    in
  let=? ctxt :=
    match no_reward_cycles with
    | None => Error_monad.__return ctxt
    | Some cycles =>
      let constants := Raw_context.constants ctxt in
      let= ctxt :=
        Raw_context.patch_constants ctxt
          (fun c =>
            Constants_repr.parametric.with_endorsement_reward Tez_repr.zero
              (Constants_repr.parametric.with_block_reward Tez_repr.zero c)) in
      (|Storage.Ramp_up.Rewards|).(Storage_sigs.Indexed_data_storage.init) ctxt
        (Cycle_repr.of_int32_exn (Int32.of_int cycles))
        (constants.(Constants_repr.parametric.block_reward),
          constants.(Constants_repr.parametric.endorsement_reward))
    end in
  match ramp_up_cycles with
  | None => Error_monad.__return ctxt
  | Some cycles =>
    let constants := Raw_context.constants ctxt in
    let=? block_step :=
      Lwt.__return
        (Tez_repr.op_divquestion
          constants.(Constants_repr.parametric.block_security_deposit)
          (Int64.of_int cycles)) in
    let=? endorsement_step :=
      Lwt.__return
        (Tez_repr.op_divquestion
          constants.(Constants_repr.parametric.endorsement_security_deposit)
          (Int64.of_int cycles)) in
    let= ctxt :=
      Raw_context.patch_constants ctxt
        (fun c =>
          Constants_repr.parametric.with_endorsement_security_deposit
            Tez_repr.zero
            (Constants_repr.parametric.with_block_security_deposit Tez_repr.zero
              c)) in
    let=? ctxt :=
      Error_monad.fold_left_s
        (fun ctxt =>
          fun cycle =>
            let=? block_security_deposit :=
              Lwt.__return
                (Tez_repr.op_starquestion block_step (Int64.of_int cycle)) in
            let=? endorsement_security_deposit :=
              Lwt.__return
                (Tez_repr.op_starquestion endorsement_step (Int64.of_int cycle))
              in
            let cycle := Cycle_repr.of_int32_exn (Int32.of_int cycle) in
            (|Storage.Ramp_up.Security_deposits|).(Storage_sigs.Indexed_data_storage.init)
              ctxt cycle (block_security_deposit, endorsement_security_deposit))
        ctxt (Misc.op_minusminusgt 1 (Pervasives.op_minus cycles 1)) in
    let=? ctxt :=
      (|Storage.Ramp_up.Security_deposits|).(Storage_sigs.Indexed_data_storage.init)
        ctxt (Cycle_repr.of_int32_exn (Int32.of_int cycles))
        (constants.(Constants_repr.parametric.block_security_deposit),
          constants.(Constants_repr.parametric.endorsement_security_deposit)) in
    Error_monad.__return ctxt
  end.

Definition cycle_end
  (ctxt :
    (|Storage.Ramp_up.Rewards|).(Storage_sigs.Indexed_data_storage.context))
  (last_cycle : Cycle_repr.cycle)
  : Lwt.t
    (Error_monad.tzresult
      (|Storage.Ramp_up.Rewards|).(Storage_sigs.Indexed_data_storage.context)) :=
  let next_cycle := Cycle_repr.succ last_cycle in
  let=? ctxt :=
    let=? function_parameter :=
      (|Storage.Ramp_up.Rewards|).(Storage_sigs.Indexed_data_storage.get_option)
        ctxt next_cycle in
    match function_parameter with
    | None => Error_monad.__return ctxt
    | Some (block_reward, endorsement_reward) =>
      let=? ctxt :=
        (|Storage.Ramp_up.Rewards|).(Storage_sigs.Indexed_data_storage.delete)
          ctxt next_cycle in
      let= ctxt :=
        Raw_context.patch_constants ctxt
          (fun c =>
            Constants_repr.parametric.with_endorsement_reward endorsement_reward
              (Constants_repr.parametric.with_block_reward block_reward c)) in
      Error_monad.__return ctxt
    end in
  let=? function_parameter :=
    (|Storage.Ramp_up.Security_deposits|).(Storage_sigs.Indexed_data_storage.get_option)
      ctxt next_cycle in
  match function_parameter with
  | None => Error_monad.__return ctxt
  | Some (block_security_deposit, endorsement_security_deposit) =>
    let=? ctxt :=
      (|Storage.Ramp_up.Security_deposits|).(Storage_sigs.Indexed_data_storage.delete)
        ctxt next_cycle in
    let= ctxt :=
      Raw_context.patch_constants ctxt
        (fun c =>
          Constants_repr.parametric.with_endorsement_security_deposit
            endorsement_security_deposit
            (Constants_repr.parametric.with_block_security_deposit
              block_security_deposit c)) in
    Error_monad.__return ctxt
  end.
