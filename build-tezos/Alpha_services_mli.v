(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Alpha_context.
Require Tezos.Constants_services.
Require Tezos.Contract_services.
Require Tezos.Delegate_services.
Require Tezos.Helpers_services.
Require Tezos.Nonce_hash.
Require Tezos.Voting_services.

Import Alpha_context.

Module Seed.
  Parameter get : forall {a : Set},
    RPC_context.simple a -> a ->
    Lwt.t (Error_monad.shell_tzresult Alpha_context.Seed.seed).
End Seed.

Module Nonce.
  Inductive info : Set :=
  | Revealed : Alpha_context.Nonce.t -> info
  | Missing : Nonce_hash.t -> info
  | Forgotten : info.
  
  Parameter get : forall {a : Set},
    RPC_context.simple a -> a -> Alpha_context.Raw_level.t ->
    Lwt.t (Error_monad.shell_tzresult info).
End Nonce.

Module Contract := Contract_services.

Module Constants := Constants_services.

Module Delegate := Delegate_services.

Module Helpers := Helpers_services.

Module Forge := Helpers_services.Forge.

Module Parse := Helpers_services.Parse.

Module Voting := Voting_services.

Parameter register : unit -> unit.