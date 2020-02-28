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

Definition CompareModule :=
  Compare.Make
    (let t : Set := t in
    let compare (function_parameter : t) : t -> int :=
      let '{| t.level := l1 |} := function_parameter in
      fun function_parameter =>
        let '{| t.level := l2 |} := function_parameter in
        Raw_level_repr.compare l1 l2 in
    existT (A := Set) _ _
      {|
        Compare.COMPARABLE.compare := compare
      |}).

Definition op_eq := (|CompareModule|).(Compare.S.op_eq).

Definition op_ltgt := (|CompareModule|).(Compare.S.op_ltgt).

Definition op_lt := (|CompareModule|).(Compare.S.op_lt).

Definition op_lteq := (|CompareModule|).(Compare.S.op_lteq).

Definition op_gteq := (|CompareModule|).(Compare.S.op_gteq).

Definition op_gt := (|CompareModule|).(Compare.S.op_gt).

Definition compare := (|CompareModule|).(Compare.S.compare).

Definition equal := (|CompareModule|).(Compare.S.equal).

Definition max := (|CompareModule|).(Compare.S.max).

Definition min := (|CompareModule|).(Compare.S.min).

Definition level : Set := t.

Definition pp (ppf : Format.formatter) (function_parameter : t) : unit :=
  let '{| t.level := level |} := function_parameter in
  Raw_level_repr.pp ppf level.

Definition pp_full (ppf : Format.formatter) (l : t) : unit :=
  Format.fprintf ppf
    (CamlinternalFormatBasics.Format
      (CamlinternalFormatBasics.Alpha
        (CamlinternalFormatBasics.Char_literal "." % char
          (CamlinternalFormatBasics.Int32 CamlinternalFormatBasics.Int_d
            CamlinternalFormatBasics.No_padding
            CamlinternalFormatBasics.No_precision
            (CamlinternalFormatBasics.String_literal " (cycle "
              (CamlinternalFormatBasics.Alpha
                (CamlinternalFormatBasics.Char_literal "." % char
                  (CamlinternalFormatBasics.Int32 CamlinternalFormatBasics.Int_d
                    CamlinternalFormatBasics.No_padding
                    CamlinternalFormatBasics.No_precision
                    (CamlinternalFormatBasics.String_literal ") (vote "
                      (CamlinternalFormatBasics.Alpha
                        (CamlinternalFormatBasics.Char_literal "." % char
                          (CamlinternalFormatBasics.Int32
                            CamlinternalFormatBasics.Int_d
                            CamlinternalFormatBasics.No_padding
                            CamlinternalFormatBasics.No_precision
                            (CamlinternalFormatBasics.Char_literal ")" % char
                              CamlinternalFormatBasics.End_of_format))))))))))))
      "%a.%ld (cycle %a.%ld) (vote %a.%ld)") Raw_level_repr.pp l.(t.level)
    l.(t.level_position) Cycle_repr.pp l.(t.cycle) l.(t.cycle_position)
    Voting_period_repr.pp l.(t.voting_period) l.(t.voting_period_position).

Definition encoding : Data_encoding.encoding t :=
  Data_encoding.conv
    (fun function_parameter =>
      let '{|
        t.level := level;
          t.level_position := level_position;
          t.cycle := cycle;
          t.cycle_position := cycle_position;
          t.voting_period := voting_period;
          t.voting_period_position := voting_period_position;
          t.expected_commitment := expected_commitment
          |} := function_parameter in
      (level, level_position, cycle, cycle_position, voting_period,
        voting_period_position, expected_commitment))
    (fun function_parameter =>
      let
        '(level, level_position, cycle, cycle_position, voting_period,
          voting_period_position, expected_commitment) := function_parameter in
      {| t.level := level; t.level_position := level_position; t.cycle := cycle;
        t.cycle_position := cycle_position; t.voting_period := voting_period;
        t.voting_period_position := voting_period_position;
        t.expected_commitment := expected_commitment |}) None
    (Data_encoding.obj7
      (Data_encoding.req None
        (Some
          "The level of the block relative to genesis. This is also the Shell's notion of level")
        "level" Raw_level_repr.encoding)
      (Data_encoding.req None
        (Some
          "The level of the block relative to the block that starts protocol alpha. This is specific to the protocol alpha. Other protocols might or might not include a similar notion.")
        "level_position" Data_encoding.__int32_value)
      (Data_encoding.req None
        (Some
          "The current cycle's number. Note that cycles are a protocol-specific notion. As a result, the cycle number starts at 0 with the first block of protocol alpha.")
        "cycle" Cycle_repr.encoding)
      (Data_encoding.req None
        (Some
          "The current level of the block relative to the first block of the current cycle.")
        "cycle_position" Data_encoding.__int32_value)
      (Data_encoding.req None
        (Some
          "The current voting period's index. Note that cycles are a protocol-specific notion. As a result, the voting period index starts at 0 with the first block of protocol alpha.")
        "voting_period" Voting_period_repr.encoding)
      (Data_encoding.req None
        (Some
          "The current level of the block relative to the first block of the current voting period.")
        "voting_period_position" Data_encoding.__int32_value)
      (Data_encoding.req None
        (Some
          "Tells wether the baker of this block has to commit a seed nonce hash.")
        "expected_commitment" Data_encoding.__bool_value)).

Definition root_level (first_level : Raw_level_repr.t) : t :=
  {| t.level := first_level;
    t.level_position :=
      (* ❌ Constant of type int32 is converted to int *)
      0; t.cycle := Cycle_repr.root;
    t.cycle_position :=
      (* ❌ Constant of type int32 is converted to int *)
      0; t.voting_period := Voting_period_repr.root;
    t.voting_period_position :=
      (* ❌ Constant of type int32 is converted to int *)
      0; t.expected_commitment := false |}.

Definition from_raw_level
  (first_level : Raw_level_repr.raw_level) (blocks_per_cycle : int32)
  (blocks_per_voting_period : int32) (blocks_per_commitment : int32)
  (level : Raw_level_repr.raw_level) : t :=
  let raw_level := Raw_level_repr.to_int32 level in
  let first_level := Raw_level_repr.to_int32 first_level in
  let level_position :=
    (|Compare.Int32|).(Compare.S.max)
      (* ❌ Constant of type int32 is converted to int *)
      0 (Int32.sub raw_level first_level) in
  let cycle :=
    Cycle_repr.of_int32_exn (Int32.div level_position blocks_per_cycle) in
  let cycle_position := Int32.rem level_position blocks_per_cycle in
  let voting_period :=
    Voting_period_repr.of_int32_exn
      (Int32.div level_position blocks_per_voting_period) in
  let voting_period_position :=
    Int32.rem level_position blocks_per_voting_period in
  let expected_commitment :=
    (|Compare.Int32|).(Compare.S.op_eq)
      (Int32.rem cycle_position blocks_per_commitment)
      (Int32.pred blocks_per_commitment) in
  {| t.level := level; t.level_position := level_position; t.cycle := cycle;
    t.cycle_position := cycle_position; t.voting_period := voting_period;
    t.voting_period_position := voting_period_position;
    t.expected_commitment := expected_commitment |}.

Definition diff (function_parameter : t) : t -> int32 :=
  let '{| t.level := l1 |} := function_parameter in
  fun function_parameter =>
    let '{| t.level := l2 |} := function_parameter in
    Int32.sub (Raw_level_repr.to_int32 l1) (Raw_level_repr.to_int32 l2).
