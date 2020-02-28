(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Cycle_repr.
Require Tezos.Raw_level_repr.
Require Tezos.Voting_period_repr.

Module t.
  Record record : Set := Build {
    level : Raw_level_repr.t;
    level_position : int32;
    cycle : Cycle_repr.t;
    cycle_position : int32;
    voting_period : Voting_period_repr.t;
    voting_period_position : int32;
    expected_commitment : bool }.
  Definition with_level level (r : record) :=
    Build level r.(level_position) r.(cycle) r.(cycle_position)
      r.(voting_period) r.(voting_period_position) r.(expected_commitment).
  Definition with_level_position level_position (r : record) :=
    Build r.(level) level_position r.(cycle) r.(cycle_position)
      r.(voting_period) r.(voting_period_position) r.(expected_commitment).
  Definition with_cycle cycle (r : record) :=
    Build r.(level) r.(level_position) cycle r.(cycle_position)
      r.(voting_period) r.(voting_period_position) r.(expected_commitment).
  Definition with_cycle_position cycle_position (r : record) :=
    Build r.(level) r.(level_position) r.(cycle) cycle_position
      r.(voting_period) r.(voting_period_position) r.(expected_commitment).
  Definition with_voting_period voting_period (r : record) :=
    Build r.(level) r.(level_position) r.(cycle) r.(cycle_position)
      voting_period r.(voting_period_position) r.(expected_commitment).
  Definition with_voting_period_position voting_period_position (r : record) :=
    Build r.(level) r.(level_position) r.(cycle) r.(cycle_position)
      r.(voting_period) voting_period_position r.(expected_commitment).
  Definition with_expected_commitment expected_commitment (r : record) :=
    Build r.(level) r.(level_position) r.(cycle) r.(cycle_position)
      r.(voting_period) r.(voting_period_position) expected_commitment.
End t.
Definition t := t.record.

Definition level : Set := t.

Parameter Included_S : {_ : unit & Compare.S.signature level}.

Definition op_eq : level -> level -> bool := (|Included_S|).(Compare.S.op_eq).

Definition op_ltgt : level -> level -> bool :=
  (|Included_S|).(Compare.S.op_ltgt).

Definition op_lt : level -> level -> bool := (|Included_S|).(Compare.S.op_lt).

Definition op_lteq : level -> level -> bool :=
  (|Included_S|).(Compare.S.op_lteq).

Definition op_gteq : level -> level -> bool :=
  (|Included_S|).(Compare.S.op_gteq).

Definition op_gt : level -> level -> bool := (|Included_S|).(Compare.S.op_gt).

Definition compare : level -> level -> int :=
  (|Included_S|).(Compare.S.compare).

Definition equal : level -> level -> bool := (|Included_S|).(Compare.S.equal).

Definition max : level -> level -> level := (|Included_S|).(Compare.S.max).

Definition min : level -> level -> level := (|Included_S|).(Compare.S.min).

Parameter encoding : Data_encoding.t level.

Parameter pp : Format.formatter -> level -> unit.

Parameter pp_full : Format.formatter -> level -> unit.

Parameter root_level : Raw_level_repr.t -> level.

Parameter from_raw_level :
  Raw_level_repr.t -> int32 -> int32 -> int32 -> Raw_level_repr.t -> level.

Parameter diff : level -> level -> int32.
