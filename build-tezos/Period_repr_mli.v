(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.

Parameter t : Set.

Definition period : Set := t.

Parameter Included_S : {_ : unit & Compare.S.signature t}.

Definition op_eq : t -> t -> bool := (|Included_S|).(Compare.S.op_eq).

Definition op_ltgt : t -> t -> bool := (|Included_S|).(Compare.S.op_ltgt).

Definition op_lt : t -> t -> bool := (|Included_S|).(Compare.S.op_lt).

Definition op_lteq : t -> t -> bool := (|Included_S|).(Compare.S.op_lteq).

Definition op_gteq : t -> t -> bool := (|Included_S|).(Compare.S.op_gteq).

Definition op_gt : t -> t -> bool := (|Included_S|).(Compare.S.op_gt).

Definition compare : t -> t -> int := (|Included_S|).(Compare.S.compare).

Definition equal : t -> t -> bool := (|Included_S|).(Compare.S.equal).

Definition max : t -> t -> t := (|Included_S|).(Compare.S.max).

Definition min : t -> t -> t := (|Included_S|).(Compare.S.min).

Parameter encoding : Data_encoding.t period.

Parameter rpc_arg : RPC_arg.t period.

Parameter pp : Format.formatter -> period -> unit.

Parameter to_seconds : period -> int64.

Parameter of_seconds : int64 -> Error_monad.tzresult period.

Parameter of_seconds_exn : int64 -> period.

Parameter mult : int32 -> period -> Error_monad.tzresult period.

Parameter zero : period.

Parameter one_second : period.

Parameter one_minute : period.

Parameter one_hour : period.
