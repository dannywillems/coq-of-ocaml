(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Alpha_context.
Require Tezos.Contract_repr.

Import Alpha_context.

Parameter __list_value : forall {E F H J K a b c i o q : Set},
  (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
    (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
      (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
      a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (H * a * b * q * i * o)) *
        (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (J * a * b * c * q * i * o)) * K)))) * K * a -> a -> option bool ->
  option bool -> unit ->
  Lwt.t
    (Error_monad.shell_tzresult
      (list (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))).

Module info.
  Record record : Set := Build {
    balance : Alpha_context.Tez.t;
    frozen_balance : Alpha_context.Tez.t;
    frozen_balance_by_cycle :
      (|Alpha_context.Cycle.Map|).(S.MAP.t)
        Alpha_context.Delegate.frozen_balance;
    staking_balance : Alpha_context.Tez.t;
    delegated_contracts : list Contract_repr.t;
    delegated_balance : Alpha_context.Tez.t;
    deactivated : bool;
    grace_period : Alpha_context.Cycle.t }.
  Definition with_balance balance (r : record) :=
    Build balance r.(frozen_balance) r.(frozen_balance_by_cycle)
      r.(staking_balance) r.(delegated_contracts) r.(delegated_balance)
      r.(deactivated) r.(grace_period).
  Definition with_frozen_balance frozen_balance (r : record) :=
    Build r.(balance) frozen_balance r.(frozen_balance_by_cycle)
      r.(staking_balance) r.(delegated_contracts) r.(delegated_balance)
      r.(deactivated) r.(grace_period).
  Definition with_frozen_balance_by_cycle frozen_balance_by_cycle
    (r : record) :=
    Build r.(balance) r.(frozen_balance) frozen_balance_by_cycle
      r.(staking_balance) r.(delegated_contracts) r.(delegated_balance)
      r.(deactivated) r.(grace_period).
  Definition with_staking_balance staking_balance (r : record) :=
    Build r.(balance) r.(frozen_balance) r.(frozen_balance_by_cycle)
      staking_balance r.(delegated_contracts) r.(delegated_balance)
      r.(deactivated) r.(grace_period).
  Definition with_delegated_contracts delegated_contracts (r : record) :=
    Build r.(balance) r.(frozen_balance) r.(frozen_balance_by_cycle)
      r.(staking_balance) delegated_contracts r.(delegated_balance)
      r.(deactivated) r.(grace_period).
  Definition with_delegated_balance delegated_balance (r : record) :=
    Build r.(balance) r.(frozen_balance) r.(frozen_balance_by_cycle)
      r.(staking_balance) r.(delegated_contracts) delegated_balance
      r.(deactivated) r.(grace_period).
  Definition with_deactivated deactivated (r : record) :=
    Build r.(balance) r.(frozen_balance) r.(frozen_balance_by_cycle)
      r.(staking_balance) r.(delegated_contracts) r.(delegated_balance)
      deactivated r.(grace_period).
  Definition with_grace_period grace_period (r : record) :=
    Build r.(balance) r.(frozen_balance) r.(frozen_balance_by_cycle)
      r.(staking_balance) r.(delegated_contracts) r.(delegated_balance)
      r.(deactivated) grace_period.
End info.
Definition info := info.record.

Parameter info_encoding : Data_encoding.t info.

Parameter __info_value : forall {E F H J K a b c i o q : Set},
  (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
    (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
      (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
      a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (H * a * b * q * i * o)) *
        (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Lwt.t (Error_monad.shell_tzresult info).

Parameter balance : forall {E F H J K a b c i o q : Set},
  (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
    (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
      (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
      a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (H * a * b * q * i * o)) *
        (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.Tez.t).

Parameter __frozen_balance_value : forall {E F H J K a b c i o q : Set},
  (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
    (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
      (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
      a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (H * a * b * q * i * o)) *
        (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.Tez.t).

Parameter frozen_balance_by_cycle : forall {E F H J K a b c i o q : Set},
  (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
    (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
      (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
      a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (H * a * b * q * i * o)) *
        (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Lwt.t
    (Error_monad.shell_tzresult
      ((|Alpha_context.Cycle.Map|).(S.MAP.t)
        Alpha_context.Delegate.frozen_balance)).

Parameter staking_balance : forall {E F H J K a b c i o q : Set},
  (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
    (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
      (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
      a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (H * a * b * q * i * o)) *
        (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.Tez.t).

Parameter delegated_contracts : forall {E F H J K a b c i o q : Set},
  (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
    (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
      (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
      a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (H * a * b * q * i * o)) *
        (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Lwt.t (Error_monad.shell_tzresult (list Contract_repr.t)).

Parameter delegated_balance : forall {E F H J K a b c i o q : Set},
  (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
    (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
      (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
      a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (H * a * b * q * i * o)) *
        (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.Tez.t).

Parameter deactivated : forall {E F H J K a b c i o q : Set},
  (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
    (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
      (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
      a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (H * a * b * q * i * o)) *
        (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Lwt.t (Error_monad.shell_tzresult bool).

Parameter grace_period : forall {E F H J K a b c i o q : Set},
  (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
    (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
      (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
      a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        (H * a * b * q * i * o)) *
        (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.Cycle.t).

Module Baking_rights.
  Module t.
    Record record : Set := Build {
      level : Alpha_context.Raw_level.t;
      delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t);
      priority : int;
      timestamp : option Alpha_context.Timestamp.t }.
    Definition with_level level (r : record) :=
      Build level r.(delegate) r.(priority) r.(timestamp).
    Definition with_delegate delegate (r : record) :=
      Build r.(level) delegate r.(priority) r.(timestamp).
    Definition with_priority priority (r : record) :=
      Build r.(level) r.(delegate) priority r.(timestamp).
    Definition with_timestamp timestamp (r : record) :=
      Build r.(level) r.(delegate) r.(priority) timestamp.
  End t.
  Definition t := t.record.
  
  Parameter get : forall {E F H J K a b c i o q : Set},
    (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
    Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
      i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
        (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
        a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (H * a * b * q * i * o)) *
          (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o
          -> a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o))
            * (J * a * b * c * q * i * o)) * K)))) * K * a ->
    option (list Alpha_context.Raw_level.t) ->
    option (list Alpha_context.Cycle.t) ->
    option (list Signature.public_key_hash) -> option bool -> option int -> a ->
    Lwt.t (Error_monad.shell_tzresult (list t)).
End Baking_rights.

Module Endorsing_rights.
  Module t.
    Record record : Set := Build {
      level : Alpha_context.Raw_level.t;
      delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t);
      slots : list int;
      estimated_time : option Alpha_context.Timestamp.t }.
    Definition with_level level (r : record) :=
      Build level r.(delegate) r.(slots) r.(estimated_time).
    Definition with_delegate delegate (r : record) :=
      Build r.(level) delegate r.(slots) r.(estimated_time).
    Definition with_slots slots (r : record) :=
      Build r.(level) r.(delegate) slots r.(estimated_time).
    Definition with_estimated_time estimated_time (r : record) :=
      Build r.(level) r.(delegate) r.(slots) estimated_time.
  End t.
  Definition t := t.record.
  
  Parameter get : forall {E F H J K a b c i o q : Set},
    (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
    Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
      i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
        (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
        a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (H * a * b * q * i * o)) *
          (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o
          -> a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o))
            * (J * a * b * c * q * i * o)) * K)))) * K * a ->
    option (list Alpha_context.Raw_level.t) ->
    option (list Alpha_context.Cycle.t) ->
    option (list Signature.public_key_hash) -> a ->
    Lwt.t (Error_monad.shell_tzresult (list t)).
End Endorsing_rights.

Module Endorsing_power.
  Parameter get : forall {E F H J K a b c i o q : Set},
    (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
    Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
      i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
        (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
        a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (H * a * b * q * i * o)) *
          (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o
          -> a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o))
            * (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
    Alpha_context.packed_operation -> (|Chain_id|).(S.HASH.t) ->
    Lwt.t (Error_monad.shell_tzresult int).
End Endorsing_power.

Module Required_endorsements.
  Parameter get : forall {E F H J K a b c i o q : Set},
    (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
    Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
      i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
        (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
        a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (H * a * b * q * i * o)) *
          (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o
          -> a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o))
            * (J * a * b * c * q * i * o)) * K)))) * K * a -> a ->
    Alpha_context.Period.t -> Lwt.t (Error_monad.shell_tzresult int).
End Required_endorsements.

Module Minimal_valid_time.
  Parameter get : forall {E F H J K a b c i o q : Set},
    (((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
    Lwt.t (Error_monad.shell_tzresult o)) * (E * q * i * o)) *
      (((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
      i -> Lwt.t (Error_monad.shell_tzresult o)) * (F * a * q * i * o)) *
        (((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a ->
        a -> b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
          (H * a * b * q * i * o)) *
          (((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o
          -> a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o))
            * (J * a * b * c * q * i * o)) * K)))) * K * a -> a -> int -> int ->
    Lwt.t (Error_monad.shell_tzresult Time.t).
End Minimal_valid_time.

Parameter endorsement_rights :
  Alpha_context.t -> Alpha_context.Level.t ->
  Lwt.t (Error_monad.tzresult (list Alpha_context.public_key_hash)).

Parameter baking_rights :
  Alpha_context.t -> option int ->
  Lwt.t
    (Error_monad.tzresult
      (Alpha_context.Raw_level.t *
        list (Alpha_context.public_key_hash * option Time.t))).

Parameter endorsing_power :
  Alpha_context.t -> Alpha_context.packed_operation * (|Chain_id|).(S.HASH.t) ->
  Lwt.t (Error_monad.tzresult int).

Parameter required_endorsements :
  Alpha_context.t -> Alpha_context.Period.t -> Lwt.t (Error_monad.tzresult int).

Parameter minimal_valid_time :
  Alpha_context.t -> int -> int -> Lwt.t (Error_monad.tzresult Time.t).

Parameter register : unit -> unit.
