(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.
Require Tezos.Block_header_repr.
Require Tezos.Bootstrap_storage.
Require Tezos.Commitment_repr.
Require Tezos.Commitment_storage.
Require Tezos.Constants_repr.
Require Tezos.Constants_storage.
Require Tezos.Contract_repr.
Require Tezos.Contract_storage.
Require Tezos.Cycle_repr.
Require Tezos.Delegate_storage_mli. Module Delegate_storage := Delegate_storage_mli.
Require Tezos.Fees_storage.
Require Tezos.Fitness_repr.
Require Tezos.Fitness_storage.
Require Tezos.Gas_limit_repr.
Require Tezos.Init_storage.
Require Tezos.Legacy_script_support_repr.
Require Tezos.Level_repr.
Require Tezos.Level_storage.
Require Tezos.Michelson_v1_primitives.
Require Tezos.Nonce_storage.
Require Tezos.Operation_repr_mli. Module Operation_repr := Operation_repr_mli.
Require Tezos.Period_repr.
Require Tezos.Raw_context.
Require Tezos.Raw_level_repr.
Require Tezos.Roll_repr.
Require Tezos.Roll_storage.
Require Tezos.Script_int_repr.
Require Tezos.Script_repr.
Require Tezos.Script_timestamp_repr.
Require Tezos.Seed_repr.
Require Tezos.Seed_storage.
Require Tezos.Storage_mli. Module Storage := Storage_mli.
Require Tezos.Storage_description.
Require Tezos.Storage_sigs.
Require Tezos.Tez_repr.
Require Tezos.Time_repr.
Require Tezos.Vote_repr.
Require Tezos.Vote_storage.
Require Tezos.Voting_period_repr.

Definition t := Raw_context.t.

Definition context := t.

Module BASIC_DATA.
  Record signature {t : Set} := {
    t := t;
    op_eq : t -> t -> bool;
    op_ltgt : t -> t -> bool;
    op_lt : t -> t -> bool;
    op_lteq : t -> t -> bool;
    op_gteq : t -> t -> bool;
    op_gt : t -> t -> bool;
    compare : t -> t -> Z;
    equal : t -> t -> bool;
    max : t -> t -> t;
    min : t -> t -> t;
    encoding : Data_encoding.t t;
    pp : Format.formatter -> t -> unit;
  }.
  Arguments signature : clear implicits.
End BASIC_DATA.

Module Tez := Tez_repr.

Module Period := Period_repr.

Module Timestamp.
  Include Time_repr.
  
  Definition current : Raw_context.context -> Time.t :=
    Raw_context.current_timestamp.
End Timestamp.

Include Operation_repr.

Module Operation.
  Module t.
    Record record {kind : Set} := Build {
      shell : Operation.shell_header;
      protocol_data : protocol_data kind }.
    Arguments record : clear implicits.
    Definition with_shell {t_kind} shell (r : record t_kind) :=
      Build t_kind shell r.(protocol_data).
    Definition with_protocol_data {t_kind} protocol_data (r : record t_kind) :=
      Build t_kind r.(shell) protocol_data.
  End t.
  Definition t := t.record.
  
  Definition packed := packed_operation.
  
  Definition unsigned_encoding
    : Data_encoding.t (Operation.shell_header * packed_contents_list) :=
    unsigned_operation_encoding.
  
  Include Operation_repr.
End Operation.

Module Block_header := Block_header_repr.

Module Vote.
  Include Vote_repr.
  
  Include Vote_storage.
End Vote.

Module Raw_level := Raw_level_repr.

Module Cycle := Cycle_repr.

Module Script_int := Script_int_repr.

Module Script_timestamp.
  Include Script_timestamp_repr.
  
  Definition now (ctxt : Raw_context.context) : t :=
    let '{|
      Constants_repr.parametric.time_between_blocks := time_between_blocks
        |} := Raw_context.constants ctxt in
    match time_between_blocks with
    | [] =>
      Pervasives.failwith
        "Internal error: 'time_between_block' constants is an empty list."
    | cons first_delay _ =>
      let current_timestamp := Raw_context.predecessor_timestamp ctxt in
      Pervasives.op_pipegt
        (Pervasives.op_pipegt
          (Time.add current_timestamp (Period_repr.to_seconds first_delay))
          Timestamp.to_seconds) of_int64
    end.
End Script_timestamp.

Module Script.
  Include Michelson_v1_primitives.
  
  Include Script_repr.
  
  Definition force_decode
    (ctxt : Raw_context.context) (lexpr : Script_repr.lazy_expr)
    : Lwt.t (Error_monad.tzresult (Script_repr.expr * Raw_context.context)) :=
    Lwt.__return
      (Error_monad.op_gtgtquestion (Script_repr.force_decode lexpr)
        (fun function_parameter =>
          let '(v, cost) := function_parameter in
          Error_monad.op_gtpipequestion (Raw_context.consume_gas ctxt cost)
            (fun ctxt => (v, ctxt)))).
  
  Definition force_bytes
    (ctxt : Raw_context.context) (lexpr : Script_repr.lazy_expr)
    : Lwt.t (Error_monad.tzresult (MBytes.t * Raw_context.context)) :=
    Lwt.__return
      (Error_monad.op_gtgtquestion (Script_repr.force_bytes lexpr)
        (fun function_parameter =>
          let '(b, cost) := function_parameter in
          Error_monad.op_gtpipequestion (Raw_context.consume_gas ctxt cost)
            (fun ctxt => (b, ctxt)))).
  
  Module Legacy_support := Legacy_script_support_repr.
End Script.

Module Fees := Fees_storage.

Definition public_key := (|Signature.Public_key|).(S.SPublic_key.t).

Definition public_key_hash :=
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t).

Definition signature := Signature.t.

Module Constants.
  Include Constants_repr.
  
  Include Constants_storage.
End Constants.

Module Voting_period := Voting_period_repr.

Module Gas.
  Include Gas_limit_repr.
  
  (* ❌ Structure item `typext` not handled. *)
  (* type_extension *)
  
  Definition check_limit : Raw_context.t -> Z.t -> Error_monad.tzresult unit :=
    Raw_context.check_gas_limit.
  
  Definition set_limit : Raw_context.t -> Z.t -> Raw_context.t :=
    Raw_context.set_gas_limit.
  
  Definition set_unlimited : Raw_context.t -> Raw_context.t :=
    Raw_context.set_gas_unlimited.
  
  Definition consume
    : Raw_context.context -> Gas_limit_repr.cost ->
    Error_monad.tzresult Raw_context.context := Raw_context.consume_gas.
  
  Definition check_enough
    : Raw_context.context -> Gas_limit_repr.cost -> Error_monad.tzresult unit :=
    Raw_context.check_enough_gas.
  
  Definition level : Raw_context.t -> Gas_limit_repr.t := Raw_context.gas_level.
  
  Definition consumed : Raw_context.t -> Raw_context.t -> Z.t :=
    Raw_context.gas_consumed.
  
  Definition block_level : Raw_context.t -> Z.t := Raw_context.block_gas_level.
End Gas.

Module Level.
  Include Level_repr.
  
  Include Level_storage.
End Level.

Module Contract.
  Include Contract_repr.
  
  Include Contract_storage.
  
  Definition originate
    (c : Raw_context.t) (contract : Contract_repr.t) (balance : Tez_repr.t)
    (script : Script_repr.t * option big_map_diff)
    (delegate : option (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
    : Lwt.t (Error_monad.tzresult Raw_context.t) :=
    originate c None contract balance script delegate.
  
  Definition init_origination_nonce
    : Raw_context.t -> (|Operation_hash|).(S.HASH.t) -> Raw_context.t :=
    Raw_context.init_origination_nonce.
  
  Definition unset_origination_nonce : Raw_context.t -> Raw_context.t :=
    Raw_context.unset_origination_nonce.
End Contract.

Module Big_map.
  Definition id := Z.t.
  
  Definition fresh
    : Raw_context.t -> Lwt.t (Error_monad.tzresult (Raw_context.t * Z.t)) :=
    Storage.Big_map.Next.incr.
  
  Definition fresh_temporary
    : Raw_context.context -> Raw_context.context * Z.t :=
    Raw_context.fresh_temporary_big_map.
  
  Definition mem
    (c : Raw_context.t) (m : Z.t)
    (k :
      (|Storage.Big_map.Contents|).(Storage_sigs.Non_iterable_indexed_carbonated_data_storage.key))
    : Lwt.t (Error_monad.tzresult (Raw_context.t * bool)) :=
    (|Storage.Big_map.Contents|).(Storage_sigs.Non_iterable_indexed_carbonated_data_storage.mem)
      (c, m) k.
  
  Definition get_opt
    (c : Raw_context.t) (m : Z.t)
    (k :
      (|Storage.Big_map.Contents|).(Storage_sigs.Non_iterable_indexed_carbonated_data_storage.key))
    : Lwt.t
      (Error_monad.tzresult
        (Raw_context.t *
          option
            (|Storage.Big_map.Contents|).(Storage_sigs.Non_iterable_indexed_carbonated_data_storage.value))) :=
    (|Storage.Big_map.Contents|).(Storage_sigs.Non_iterable_indexed_carbonated_data_storage.get_option)
      (c, m) k.
  
  Definition rpc_arg : RPC_arg.t Z.t := Storage.Big_map.rpc_arg.
  
  Definition cleanup_temporary (c : Raw_context.context)
    : Lwt.t Raw_context.context :=
    Error_monad.op_gtgteq
      (Raw_context.temporary_big_maps c Storage.Big_map.remove_rec c)
      (fun c => Lwt.__return (Raw_context.reset_temporary_big_map c)).
  
  Definition __exists
    (c : Raw_context.context)
    (id : (|Storage.Big_map.Key_type|).(Storage_sigs.Indexed_data_storage.key))
    : Lwt.t
      (Error_monad.tzresult
        (Raw_context.context *
          option
            ((|Storage.Big_map.Key_type|).(Storage_sigs.Indexed_data_storage.value)
              *
              (|Storage.Big_map.Value_type|).(Storage_sigs.Indexed_data_storage.value)))) :=
    Error_monad.op_gtgteqquestion
      (Lwt.__return
        (Raw_context.consume_gas c (Gas_limit_repr.read_bytes_cost Z.zero)))
      (fun c =>
        Error_monad.op_gtgteqquestion
          ((|Storage.Big_map.Key_type|).(Storage_sigs.Indexed_data_storage.get_option)
            c id)
          (fun kt =>
            match kt with
            | None => Error_monad.__return (c, None)
            | Some kt =>
              Error_monad.op_gtgteqquestion
                ((|Storage.Big_map.Value_type|).(Storage_sigs.Indexed_data_storage.get)
                  c id) (fun kv => Error_monad.__return (c, (Some (kt, kv))))
            end)).
End Big_map.

Module Delegate := Delegate_storage.

Module Roll.
  Include Roll_repr.
  
  Include Roll_storage.
End Roll.

Module Nonce := Nonce_storage.

Module Seed.
  Include Seed_repr.
  
  Include Seed_storage.
End Seed.

Module Fitness.
  Include Fitness_repr.
  
  Definition t := (|Fitness|).(S.T.t).
  
  Definition op_eq := (|Fitness|).(S.T.op_eq).
  
  Definition op_ltgt := (|Fitness|).(S.T.op_ltgt).
  
  Definition op_lt := (|Fitness|).(S.T.op_lt).
  
  Definition op_lteq := (|Fitness|).(S.T.op_lteq).
  
  Definition op_gteq := (|Fitness|).(S.T.op_gteq).
  
  Definition op_gt := (|Fitness|).(S.T.op_gt).
  
  Definition compare := (|Fitness|).(S.T.compare).
  
  Definition equal := (|Fitness|).(S.T.equal).
  
  Definition max := (|Fitness|).(S.T.max).
  
  Definition min := (|Fitness|).(S.T.min).
  
  Definition pp := (|Fitness|).(S.T.pp).
  
  Definition encoding := (|Fitness|).(S.T.encoding).
  
  Definition to_bytes := (|Fitness|).(S.T.to_bytes).
  
  Definition of_bytes := (|Fitness|).(S.T.of_bytes).
  
  Definition fitness := t.
  
  Include Fitness_storage.
End Fitness.

Module Bootstrap := Bootstrap_storage.

Module Commitment.
  Definition t := (|Commitment_repr|).(Storage_sigs.VALUE.t).
  
  Definition encoding := (|Commitment_repr|).(Storage_sigs.VALUE.encoding).
  
  Include Commitment_storage.
End Commitment.

Module Global.
  Definition get_block_priority
    : Raw_context.t -> Lwt.t (Error_monad.tzresult Z) :=
    Storage.Block_priority.get.
  
  Definition set_block_priority
    : Raw_context.t -> Z -> Lwt.t (Error_monad.tzresult Raw_context.t) :=
    Storage.Block_priority.set.
End Global.

Definition prepare_first_block
  : Context.t ->
  (Raw_context.t -> Script_repr.t ->
  Lwt.t
    (Error_monad.tzresult
      ((Script_repr.t * option Contract_storage.big_map_diff) * Raw_context.t)))
  -> int32 -> Time.t -> (|Fitness|).(S.T.t) ->
  Lwt.t (Error_monad.tzresult Raw_context.t) := Init_storage.prepare_first_block.

Definition prepare
  : Context.t -> Int32.t -> Time.t -> Time.t -> (|Fitness|).(S.T.t) ->
  Lwt.t (Error_monad.tzresult Raw_context.context) := Init_storage.prepare.

Definition finalize (message : option string) (c : Raw_context.context)
  : Updater.validation_result :=
  let fitness := Fitness.from_int64 (Fitness.current c) in
  let context := Raw_context.recover c in
  {| Updater.validation_result.context := context;
    Updater.validation_result.fitness := fitness;
    Updater.validation_result.message := message;
    Updater.validation_result.max_operations_ttl := 60;
    Updater.validation_result.last_allowed_fork_level :=
      Pervasives.op_atat Raw_level.to_int32 (Level.last_allowed_fork_level c) |}.

Definition activate
  : Raw_context.context -> (|Protocol_hash|).(S.HASH.t) -> Lwt.t Raw_context.t :=
  Raw_context.activate.

Definition fork_test_chain
  : Raw_context.context -> (|Protocol_hash|).(S.HASH.t) -> Time.t ->
  Lwt.t Raw_context.t := Raw_context.fork_test_chain.

Definition record_endorsement
  : Raw_context.context ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) -> Raw_context.context :=
  Raw_context.record_endorsement.

Definition allowed_endorsements
  : Raw_context.context ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.Map).(S.INDEXES_Map.t)
    ((|Signature.Public_key|).(S.SPublic_key.t) * list Z * bool) :=
  Raw_context.allowed_endorsements.

Definition init_endorsements
  : Raw_context.context ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.Map).(S.INDEXES_Map.t)
    ((|Signature.Public_key|).(S.SPublic_key.t) * list Z * bool) ->
  Raw_context.context := Raw_context.init_endorsements.

Definition included_endorsements : Raw_context.context -> Z :=
  Raw_context.included_endorsements.

Definition reset_internal_nonce : Raw_context.context -> Raw_context.context :=
  Raw_context.reset_internal_nonce.

Definition fresh_internal_nonce
  : Raw_context.context -> Error_monad.tzresult (Raw_context.context * Z) :=
  Raw_context.fresh_internal_nonce.

Definition record_internal_nonce
  : Raw_context.context -> Z -> Raw_context.context :=
  Raw_context.record_internal_nonce.

Definition internal_nonce_already_recorded : Raw_context.context -> Z -> bool :=
  Raw_context.internal_nonce_already_recorded.

Definition add_deposit
  : Raw_context.context ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) -> Tez_repr.t ->
  Lwt.t (Error_monad.tzresult Raw_context.context) := Raw_context.add_deposit.

Definition add_fees
  : Raw_context.context -> Tez_repr.t ->
  Lwt.t (Error_monad.tzresult Raw_context.context) := Raw_context.add_fees.

Definition add_rewards
  : Raw_context.context -> Tez_repr.t ->
  Lwt.t (Error_monad.tzresult Raw_context.context) := Raw_context.add_rewards.

Definition get_deposits
  : Raw_context.context ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.Map).(S.INDEXES_Map.t)
    Tez_repr.t := Raw_context.get_deposits.

Definition get_fees : Raw_context.context -> Tez_repr.t := Raw_context.get_fees.

Definition get_rewards : Raw_context.context -> Tez_repr.t :=
  Raw_context.get_rewards.

Definition description : Storage_description.t Raw_context.context :=
  Raw_context.description.
