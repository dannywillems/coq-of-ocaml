(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Seed_repr.
Require Tezos.Storage_description.

Definition t : Set := int32.

Definition roll : Set := t.

Parameter encoding : Data_encoding.t roll.

Parameter rpc_arg : RPC_arg.t roll.

Parameter random : Seed_repr.sequence -> roll -> roll * Seed_repr.sequence.

Parameter first : roll.

Parameter succ : roll -> roll.

Parameter to_int32 : roll -> Int32.t.

Parameter op_eq : roll -> roll -> bool.

Parameter Index : {_ : unit & Storage_description.INDEX.signature roll}.
