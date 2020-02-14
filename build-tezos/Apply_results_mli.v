(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.
Require Tezos.Alpha_context.
Require Tezos.Nonce_hash.

Import Alpha_context.

Module contents_result.
  Module Endorsement_result.
    Record record {balance_updates delegate slots : Set} := {
      balance_updates : balance_updates;
      delegate : delegate;
      slots : slots }.
    Arguments record : clear implicits.
  End Endorsement_result.
  Definition Endorsement_result_skeleton := Endorsement_result.record.
  
  Module Manager_operation_result.
    Record record {balance_updates operation_result internal_operation_results :
      Set} := {
      balance_updates : balance_updates;
      operation_result : operation_result;
      internal_operation_results : internal_operation_results }.
    Arguments record : clear implicits.
  End Manager_operation_result.
  Definition Manager_operation_result_skeleton :=
    Manager_operation_result.record.
End contents_result.

Module successful_manager_operation_result.
  Module Reveal_result.
    Record record {consumed_gas : Set} := {
      consumed_gas : consumed_gas }.
    Arguments record : clear implicits.
  End Reveal_result.
  Definition Reveal_result_skeleton := Reveal_result.record.
  
  Module Transaction_result.
    Record record {storage big_map_diff balance_updates originated_contracts
      consumed_gas storage_size paid_storage_size_diff
      allocated_destination_contract : Set} := {
      storage : storage;
      big_map_diff : big_map_diff;
      balance_updates : balance_updates;
      originated_contracts : originated_contracts;
      consumed_gas : consumed_gas;
      storage_size : storage_size;
      paid_storage_size_diff : paid_storage_size_diff;
      allocated_destination_contract : allocated_destination_contract }.
    Arguments record : clear implicits.
  End Transaction_result.
  Definition Transaction_result_skeleton := Transaction_result.record.
  
  Module Origination_result.
    Record record {big_map_diff balance_updates originated_contracts
      consumed_gas storage_size paid_storage_size_diff : Set} := {
      big_map_diff : big_map_diff;
      balance_updates : balance_updates;
      originated_contracts : originated_contracts;
      consumed_gas : consumed_gas;
      storage_size : storage_size;
      paid_storage_size_diff : paid_storage_size_diff }.
    Arguments record : clear implicits.
  End Origination_result.
  Definition Origination_result_skeleton := Origination_result.record.
  
  Module Delegation_result.
    Record record {consumed_gas : Set} := {
      consumed_gas : consumed_gas }.
    Arguments record : clear implicits.
  End Delegation_result.
  Definition Delegation_result_skeleton := Delegation_result.record.
End successful_manager_operation_result.

Module operation_metadata.
  Record record {contents : Set} := Build {
    contents : contents }.
  Arguments record : clear implicits.
  Definition with_contents {t_contents} contents (r : record t_contents) :=
    Build t_contents contents.
End operation_metadata.
Definition operation_metadata_skeleton := operation_metadata.record.

Reserved Notation "'contents_result.Endorsement_result".
Reserved Notation "'contents_result.Manager_operation_result".
Reserved Notation "'successful_manager_operation_result.Reveal_result".
Reserved Notation "'successful_manager_operation_result.Transaction_result".
Reserved Notation "'successful_manager_operation_result.Origination_result".
Reserved Notation "'successful_manager_operation_result.Delegation_result".
Reserved Notation "'contents_result_list".
Reserved Notation "'operation_metadata".
Reserved Notation "'contents_result".
Reserved Notation "'manager_operation_result".
Reserved Notation "'successful_manager_operation_result".

Inductive packed_operation_metadata : Set :=
| Operation_metadata : forall {kind : Set},
  'operation_metadata kind -> packed_operation_metadata
| No_operation_metadata : packed_operation_metadata

with contents_result_list_gadt : Set :=
| Single_result : forall {kind : Set},
  'contents_result kind -> contents_result_list_gadt
| Cons_result : forall {kind : Set},
  'contents_result (Alpha_context.Kind.manager kind) ->
  contents_result_list_gadt -> contents_result_list_gadt

with packed_contents_result_list : Set :=
| Contents_result_list : forall {kind : Set},
  'contents_result_list kind -> packed_contents_result_list

with contents_result_gadt : Set :=
| Endorsement_result :
  'contents_result.Endorsement_result -> contents_result_gadt
| Seed_nonce_revelation_result :
  Alpha_context.Delegate.balance_updates -> contents_result_gadt
| Double_endorsement_evidence_result :
  Alpha_context.Delegate.balance_updates -> contents_result_gadt
| Double_baking_evidence_result :
  Alpha_context.Delegate.balance_updates -> contents_result_gadt
| Activate_account_result :
  Alpha_context.Delegate.balance_updates -> contents_result_gadt
| Proposals_result : contents_result_gadt
| Ballot_result : contents_result_gadt
| Manager_operation_result : forall {kind : Set},
  'contents_result.Manager_operation_result kind -> contents_result_gadt

with packed_contents_result : Set :=
| Contents_result : forall {kind : Set},
  'contents_result kind -> packed_contents_result

with manager_operation_result_gadt : Set :=
| Applied : forall {kind : Set},
  'successful_manager_operation_result kind -> manager_operation_result_gadt
| Backtracked : forall {kind : Set},
  'successful_manager_operation_result kind ->
  option (list Error_monad.__error) -> manager_operation_result_gadt
| Failed : forall {kind : Set},
  Alpha_context.Kind.manager kind -> list Error_monad.__error ->
  manager_operation_result_gadt
| Skipped : forall {kind : Set},
  Alpha_context.Kind.manager kind -> manager_operation_result_gadt

with successful_manager_operation_result_gadt : Set :=
| Reveal_result :
  'successful_manager_operation_result.Reveal_result ->
  successful_manager_operation_result_gadt
| Transaction_result :
  'successful_manager_operation_result.Transaction_result ->
  successful_manager_operation_result_gadt
| Origination_result :
  'successful_manager_operation_result.Origination_result ->
  successful_manager_operation_result_gadt
| Delegation_result :
  'successful_manager_operation_result.Delegation_result ->
  successful_manager_operation_result_gadt

with packed_successful_manager_operation_result : Set :=
| Successful_manager_result : forall {kind : Set},
  'successful_manager_operation_result kind ->
  packed_successful_manager_operation_result

with packed_internal_operation_result : Set :=
| Internal_operation_result : forall {kind : Set},
  Alpha_context.internal_operation kind -> 'manager_operation_result kind ->
  packed_internal_operation_result

where "'contents_result_list" := (fun (_ : Set) => contents_result_list_gadt)
and "'operation_metadata" := (fun (t_kind : Set) =>
  operation_metadata_skeleton ('contents_result_list t_kind))
and "'contents_result" := (fun (_ : Set) => contents_result_gadt)
and "'manager_operation_result" := (fun (_ : Set) =>
  manager_operation_result_gadt)
and "'successful_manager_operation_result" := (fun (_ : Set) =>
  successful_manager_operation_result_gadt)
and "'contents_result.Endorsement_result" :=
  (contents_result.Endorsement_result_skeleton
    Alpha_context.Delegate.balance_updates
    (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) (list Z))
and "'contents_result.Manager_operation_result" := (fun (t_kind : Set) =>
  contents_result.Manager_operation_result_skeleton
    Alpha_context.Delegate.balance_updates ('manager_operation_result t_kind)
    (list packed_internal_operation_result))
and "'successful_manager_operation_result.Reveal_result" :=
  (successful_manager_operation_result.Reveal_result_skeleton Z.t)
and "'successful_manager_operation_result.Transaction_result" :=
  (successful_manager_operation_result.Transaction_result_skeleton
    (option Alpha_context.Script.expr)
    (option Alpha_context.Contract.big_map_diff)
    Alpha_context.Delegate.balance_updates (list Alpha_context.Contract.t) Z.t
    Z.t Z.t bool)
and "'successful_manager_operation_result.Origination_result" :=
  (successful_manager_operation_result.Origination_result_skeleton
    (option Alpha_context.Contract.big_map_diff)
    Alpha_context.Delegate.balance_updates (list Alpha_context.Contract.t) Z.t
    Z.t Z.t)
and "'successful_manager_operation_result.Delegation_result" :=
  (successful_manager_operation_result.Delegation_result_skeleton Z.t).

Module
  ConstructorRecordNotations_packed_operation_metadata_contents_result_list_gadt_packed_contents_result_list_contents_result_gadt_packed_contents_result_manager_operation_result_gadt_successful_manager_operation_result_gadt_packed_successful_manager_operation_result_packed_internal_operation_result.
  Module contents_result.
    Definition Endorsement_result := 'contents_result.Endorsement_result.
    Definition Manager_operation_result :=
      'contents_result.Manager_operation_result.
  End contents_result.
  Module successful_manager_operation_result.
    Definition Reveal_result :=
      'successful_manager_operation_result.Reveal_result.
    Definition Transaction_result :=
      'successful_manager_operation_result.Transaction_result.
    Definition Origination_result :=
      'successful_manager_operation_result.Origination_result.
    Definition Delegation_result :=
      'successful_manager_operation_result.Delegation_result.
  End successful_manager_operation_result.
End
  ConstructorRecordNotations_packed_operation_metadata_contents_result_list_gadt_packed_contents_result_list_contents_result_gadt_packed_contents_result_manager_operation_result_gadt_successful_manager_operation_result_gadt_packed_successful_manager_operation_result_packed_internal_operation_result.
Import
  ConstructorRecordNotations_packed_operation_metadata_contents_result_list_gadt_packed_contents_result_list_contents_result_gadt_packed_contents_result_manager_operation_result_gadt_successful_manager_operation_result_gadt_packed_successful_manager_operation_result_packed_internal_operation_result.

Definition contents_result_list := 'contents_result_list.
Definition operation_metadata := 'operation_metadata.
Definition contents_result := 'contents_result.
Definition manager_operation_result := 'manager_operation_result.
Definition successful_manager_operation_result :=
  'successful_manager_operation_result.

Parameter operation_metadata_encoding :
  Data_encoding.t packed_operation_metadata.

Parameter operation_data_and_metadata_encoding :
  Data_encoding.t
    (Alpha_context.Operation.packed_protocol_data * packed_operation_metadata).

Reserved Notation "'contents_and_result_list".

Inductive contents_and_result_list_gadt : Set :=
| Single_and_result : forall {kind : Set},
  Alpha_context.contents kind -> contents_result kind ->
  contents_and_result_list_gadt
| Cons_and_result : forall {kind : Set},
  Alpha_context.contents (Alpha_context.Kind.manager kind) ->
  contents_result (Alpha_context.Kind.manager kind) ->
  contents_and_result_list_gadt -> contents_and_result_list_gadt

where "'contents_and_result_list" := (fun (_ : Set) =>
  contents_and_result_list_gadt).

Definition contents_and_result_list := 'contents_and_result_list.

Inductive packed_contents_and_result_list : Set :=
| Contents_and_result_list : forall {kind : Set},
  contents_and_result_list kind -> packed_contents_and_result_list.

Parameter contents_and_result_list_encoding :
  Data_encoding.t packed_contents_and_result_list.

Parameter pack_contents_list : forall {kind : Set},
  Alpha_context.contents_list kind -> contents_result_list kind ->
  contents_and_result_list kind.

Parameter unpack_contents_list : forall {kind : Set},
  contents_and_result_list kind ->
  Alpha_context.contents_list kind * contents_result_list kind.

Parameter to_list : packed_contents_result_list -> list packed_contents_result.

Parameter of_list : list packed_contents_result -> packed_contents_result_list.

Reserved Notation "'eq".

Inductive eq_gadt : Set :=
| Eq : eq_gadt

where "'eq" := (fun (_ _ : Set) => eq_gadt).

Definition eq := 'eq.

Parameter kind_equal_list : forall {kind kind2 : Set},
  Alpha_context.contents_list kind -> contents_result_list kind2 ->
  option (eq kind kind2).

Module block_metadata.
  Record record := Build {
    baker : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t);
    level : Alpha_context.Level.t;
    voting_period_kind : Alpha_context.Voting_period.kind;
    nonce_hash : option Nonce_hash.t;
    consumed_gas : Z.t;
    deactivated : list (|Signature.Public_key_hash|).(S.SPublic_key_hash.t);
    balance_updates : Alpha_context.Delegate.balance_updates }.
  Definition with_baker baker (r : record) :=
    Build baker r.(level) r.(voting_period_kind) r.(nonce_hash) r.(consumed_gas)
      r.(deactivated) r.(balance_updates).
  Definition with_level level (r : record) :=
    Build r.(baker) level r.(voting_period_kind) r.(nonce_hash) r.(consumed_gas)
      r.(deactivated) r.(balance_updates).
  Definition with_voting_period_kind voting_period_kind (r : record) :=
    Build r.(baker) r.(level) voting_period_kind r.(nonce_hash) r.(consumed_gas)
      r.(deactivated) r.(balance_updates).
  Definition with_nonce_hash nonce_hash (r : record) :=
    Build r.(baker) r.(level) r.(voting_period_kind) nonce_hash r.(consumed_gas)
      r.(deactivated) r.(balance_updates).
  Definition with_consumed_gas consumed_gas (r : record) :=
    Build r.(baker) r.(level) r.(voting_period_kind) r.(nonce_hash) consumed_gas
      r.(deactivated) r.(balance_updates).
  Definition with_deactivated deactivated (r : record) :=
    Build r.(baker) r.(level) r.(voting_period_kind) r.(nonce_hash)
      r.(consumed_gas) deactivated r.(balance_updates).
  Definition with_balance_updates balance_updates (r : record) :=
    Build r.(baker) r.(level) r.(voting_period_kind) r.(nonce_hash)
      r.(consumed_gas) r.(deactivated) balance_updates.
End block_metadata.
Definition block_metadata := block_metadata.record.

Parameter block_metadata_encoding : Data_encoding.encoding block_metadata.
