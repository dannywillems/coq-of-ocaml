(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import TypingFlags.Loader.
Unset Guard Checking.

Definition f (n : Z) (b : bool) : Z :=
  if b then
    Z.add n 1
  else
    Z.sub n 1.

Definition id {a : Set} (x : a) : a := x.
