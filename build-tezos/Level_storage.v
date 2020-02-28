(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.
Unset Guard Checking.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Constants_repr.
Require Tezos.Constants_storage.
Require Tezos.Cycle_repr.
Require Tezos.Level_repr.
Require Tezos.Raw_context.
Require Tezos.Raw_level_repr.

Import Level_repr.

Definition from_raw
  (c : Raw_context.context) (offset : option int32)
  (l : Raw_level_repr.raw_level) : Level_repr.level :=
  let l :=
    match offset with
    | None => l
    | Some o =>
      Raw_level_repr.of_int32_exn (Int32.add (Raw_level_repr.to_int32 l) o)
    end in
  let constants := Raw_context.constants c in
  let first_level := Raw_context.first_level c in
  Level_repr.from_raw_level first_level
    constants.(Constants_repr.parametric.blocks_per_cycle)
    constants.(Constants_repr.parametric.blocks_per_voting_period)
    constants.(Constants_repr.parametric.blocks_per_commitment) l.

Definition root (c : Raw_context.context) : Level_repr.level :=
  Level_repr.root_level (Raw_context.first_level c).

Definition succ (c : Raw_context.context) (l : Level_repr.t)
  : Level_repr.level :=
  from_raw c None (Raw_level_repr.succ l.(Level_repr.t.level)).

Definition pred (c : Raw_context.context) (l : Level_repr.t)
  : option Level_repr.level :=
  match Raw_level_repr.pred l.(Level_repr.t.level) with
  | None => None
  | Some l => Some (from_raw c None l)
  end.

Definition current (ctxt : Raw_context.context) : Level_repr.t :=
  Raw_context.current_level ctxt.

Definition previous (ctxt : Raw_context.context) : Level_repr.level :=
  let l := current ctxt in
  match pred ctxt l with
  | None =>
    (* ❌ Assert instruction is not handled. *)
    assert Level_repr.level false
  | Some __p_value => __p_value
  end.

Definition first_level_in_cycle
  (ctxt : Raw_context.context) (c : Cycle_repr.cycle) : Level_repr.level :=
  let constants := Raw_context.constants ctxt in
  let first_level := Raw_context.first_level ctxt in
  from_raw ctxt None
    (Raw_level_repr.of_int32_exn
      (Int32.add (Raw_level_repr.to_int32 first_level)
        (Int32.mul constants.(Constants_repr.parametric.blocks_per_cycle)
          (Cycle_repr.to_int32 c)))).

Definition last_level_in_cycle
  (ctxt : Raw_context.context) (c : Cycle_repr.cycle) : Level_repr.level :=
  match pred ctxt (first_level_in_cycle ctxt (Cycle_repr.succ c)) with
  | None =>
    (* ❌ Assert instruction is not handled. *)
    assert Level_repr.level false
  | Some x => x
  end.

Definition levels_in_cycle
  (ctxt : Raw_context.context) (cycle : Cycle_repr.cycle) : list Level_repr.t :=
  let first := first_level_in_cycle ctxt cycle in
  let fix loop (n : Level_repr.t) (acc : list Level_repr.t) {struct n}
    : list Level_repr.t :=
    if Cycle_repr.op_eq n.(Level_repr.t.cycle) first.(Level_repr.t.cycle) then
      loop (succ ctxt n) (cons n acc)
    else
      acc in
  loop first nil.

Definition levels_in_current_cycle
  (ctxt : Raw_context.context) (op_staroptstar : option int32)
  : unit -> list Level_repr.t :=
  let offset :=
    match op_staroptstar with
    | Some op_starsthstar => op_starsthstar
    | None =>
      (* ❌ Constant of type int32 is converted to int *)
      0
    end in
  fun function_parameter =>
    let '_ := function_parameter in
    let current_cycle := Cycle_repr.to_int32 (current ctxt).(Level_repr.t.cycle)
      in
    let cycle := Int32.add current_cycle offset in
    if
      (|Compare.Int32|).(Compare.S.op_lt) cycle
        (* ❌ Constant of type int32 is converted to int *)
        0 then
      nil
    else
      let cycle := Cycle_repr.of_int32_exn cycle in
      levels_in_cycle ctxt cycle.

Definition levels_with_commitments_in_cycle
  (ctxt : Raw_context.context) (c : Cycle_repr.cycle) : list Level_repr.t :=
  let first := first_level_in_cycle ctxt c in
  let fix loop (n : Level_repr.t) (acc : list Level_repr.t) {struct n}
    : list Level_repr.t :=
    if Cycle_repr.op_eq n.(Level_repr.t.cycle) first.(Level_repr.t.cycle) then
      if n.(Level_repr.t.expected_commitment) then
        loop (succ ctxt n) (cons n acc)
      else
        loop (succ ctxt n) acc
    else
      acc in
  loop first nil.

Definition last_allowed_fork_level (c : Raw_context.context)
  : Raw_level_repr.raw_level :=
  let level := Raw_context.current_level c in
  let preserved_cycles := Constants_storage.preserved_cycles c in
  match Cycle_repr.sub level.(Level_repr.t.cycle) preserved_cycles with
  | None => Raw_level_repr.root
  | Some cycle => (first_level_in_cycle c cycle).(Level_repr.t.level)
  end.
