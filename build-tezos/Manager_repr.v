(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.

Inductive manager_key : Set :=
| Hash : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) -> manager_key
| Public_key : (|Signature.Public_key|).(S.SPublic_key.t) -> manager_key.

Definition t : Set := manager_key.

Import Data_encoding.

Definition hash_case (tag : Data_encoding.case_tag)
  : Data_encoding.case manager_key :=
  Data_encoding.__case_value "Public_key_hash" None tag
    (|Signature.Public_key_hash|).(S.SPublic_key_hash.encoding)
    (fun function_parameter =>
      match function_parameter with
      | Hash __hash_value => Some __hash_value
      | _ => None
      end) (fun __hash_value => Hash __hash_value).

Definition pubkey_case (tag : Data_encoding.case_tag)
  : Data_encoding.case manager_key :=
  Data_encoding.__case_value "Public_key" None tag
    (|Signature.Public_key|).(S.SPublic_key.encoding)
    (fun function_parameter =>
      match function_parameter with
      | Public_key __hash_value => Some __hash_value
      | _ => None
      end) (fun __hash_value => Public_key __hash_value).

Definition encoding : Data_encoding.encoding manager_key :=
  Data_encoding.union None
    [ hash_case (Data_encoding.Tag 0); pubkey_case (Data_encoding.Tag 1) ].
