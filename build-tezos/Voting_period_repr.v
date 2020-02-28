(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.

Definition t : Set := int32.

Definition voting_period : Set := t.

Definition op_eq := (|Compare.Int32|).(Compare.S.op_eq).

Definition op_ltgt := (|Compare.Int32|).(Compare.S.op_ltgt).

Definition op_lt := (|Compare.Int32|).(Compare.S.op_lt).

Definition op_lteq := (|Compare.Int32|).(Compare.S.op_lteq).

Definition op_gteq := (|Compare.Int32|).(Compare.S.op_gteq).

Definition op_gt := (|Compare.Int32|).(Compare.S.op_gt).

Definition compare := (|Compare.Int32|).(Compare.S.compare).

Definition equal := (|Compare.Int32|).(Compare.S.equal).

Definition max := (|Compare.Int32|).(Compare.S.max).

Definition min := (|Compare.Int32|).(Compare.S.min).

Definition encoding : Data_encoding.encoding int32 :=
  Data_encoding.__int32_value.

Definition pp (ppf : Format.formatter) (level : int32) : unit :=
  Format.fprintf ppf
    (CamlinternalFormatBasics.Format
      (CamlinternalFormatBasics.Int32 CamlinternalFormatBasics.Int_d
        CamlinternalFormatBasics.No_padding
        CamlinternalFormatBasics.No_precision
        CamlinternalFormatBasics.End_of_format) "%ld") level.

Definition rpc_arg : RPC_arg.arg int32 :=
  let construct (voting_period : int32) : string :=
    Int32.to_string voting_period in
  let destruct (str : string) : Pervasives.result int32 string :=
    let 'voting_period := Int32.of_string str in
    Pervasives.Ok voting_period in
  RPC_arg.make (Some "A voting period") "voting_period" destruct construct tt.

Definition root : int32 :=
  (* ❌ Constant of type int32 is converted to int *)
  0.

Definition succ : int32 -> int32 := Int32.succ.

Definition to_int32 {A : Set} (l : A) : A := l.

Definition of_int32_exn (l : (|Compare.Int32|).(Compare.S.t))
  : (|Compare.Int32|).(Compare.S.t) :=
  if
    (|Compare.Int32|).(Compare.S.op_gteq) l
      (* ❌ Constant of type int32 is converted to int *)
      0 then
    l
  else
    Pervasives.invalid_arg "Voting_period_repr.of_int32".

Inductive kind : Set :=
| Proposal : kind
| Testing_vote : kind
| Testing : kind
| Promotion_vote : kind.

Definition kind_encoding : Data_encoding.encoding kind :=
  Data_encoding.union (Some Data_encoding.Uint8)
    [
      Data_encoding.__case_value "Proposal" None (Data_encoding.Tag 0)
        (Data_encoding.constant "proposal")
        (fun function_parameter =>
          match function_parameter with
          | Proposal => Some tt
          | _ => None
          end)
        (fun function_parameter =>
          let '_ := function_parameter in
          Proposal);
      Data_encoding.__case_value "Testing_vote" None (Data_encoding.Tag 1)
        (Data_encoding.constant "testing_vote")
        (fun function_parameter =>
          match function_parameter with
          | Testing_vote => Some tt
          | _ => None
          end)
        (fun function_parameter =>
          let '_ := function_parameter in
          Testing_vote);
      Data_encoding.__case_value "Testing" None (Data_encoding.Tag 2)
        (Data_encoding.constant "testing")
        (fun function_parameter =>
          match function_parameter with
          | Testing => Some tt
          | _ => None
          end)
        (fun function_parameter =>
          let '_ := function_parameter in
          Testing);
      Data_encoding.__case_value "Promotion_vote" None (Data_encoding.Tag 3)
        (Data_encoding.constant "promotion_vote")
        (fun function_parameter =>
          match function_parameter with
          | Promotion_vote => Some tt
          | _ => None
          end)
        (fun function_parameter =>
          let '_ := function_parameter in
          Promotion_vote)
    ].
