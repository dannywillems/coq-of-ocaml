(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Module Source.
  Record signature {t : Set} : Set := {
    t := t;
    x : t;
    id : forall {a : Set}, a -> a;
  }.
End Source.

Module Target.
  Record signature {t : Set} : Set := {
    t := t;
    y : t;
  }.
End Target.

Module M.
  Definition t : Set := int.
  
  Definition x : int := 12.
  
  Definition id {A : Set} (x : A) : A := x.
  
  Definition module :=
    existT (A := Set) _ t
      {|
        Source.x := x;
        Source.id _ := id
      |}.
End M.
Definition M := M.module.

Module F.
  Class FArgs := {
    X : {t : Set & Source.signature (t := t)};
  }.
  
  Definition t `{FArgs} : Set := (|X|).(Source.t).
  
  Definition y `{FArgs} : (|X|).(Source.t) := (|X|).(Source.x).
  
  Definition functor `(FArgs)
    : {_ : unit & Target.signature (t := (|X|).(Source.t))} :=
    existT (A := unit) (fun _ => _) tt
      {|
        Target.y := y
      |}.
End F.
Definition F X := F.functor {| F.X := X |}.

Module FSubst.
  Class FArgs := {
    X : {t : Set & Source.signature (t := t)};
  }.
  
  Definition y `{FArgs} : (|X|).(Source.t) := (|X|).(Source.x).
  
  Definition functor `(FArgs)
    : {_ : unit & Target.signature (t := (|X|).(Source.t))} :=
    existT (A := unit) (fun _ => _) tt
      {|
        Target.y := y
      |}.
End FSubst.
Definition FSubst X := FSubst.functor {| FSubst.X := X |}.

Module Sum.
  Class FArgs := {
    X : {_ : unit & Source.signature (t := int)};
    Y : {_ : unit & Source.signature (t := int)};
  }.
  
  Definition t `{FArgs} : Set := int.
  
  Definition y `{FArgs} : int := Z.add (|X|).(Source.x) (|Y|).(Source.x).
  
  Definition functor `(FArgs) : {t : Set & Target.signature (t := t)} :=
    existT (A := Set) _ t
      {|
        Target.y := y
      |}.
End Sum.
Definition Sum X Y := Sum.functor {| Sum.X := X; Sum.Y := Y |}.

Module WithM.
  Definition t := (|M|).(Source.t).
  
  Definition x := (|M|).(Source.x).
  
  Definition id {a : Set} := (|M|).(Source.id) (a := a).
  
  Definition z : int := 0.
End WithM.

Module WithSum.
  Definition F_include := F (existT (A := Set) _ _ (|M|)).
  
  Definition t := (|F_include|).(Target.t).
  
  Definition y := (|F_include|).(Target.y).
  
  Definition z : int := 0.
End WithSum.

Module GenFun.
  Definition t : Set := int.
  
  Definition y : int := 23.
  
  Definition module :=
    existT (A := Set) _ t
      {|
        Target.y := y
      |}.
End GenFun.
Definition GenFun := GenFun.module.

Definition AppliedGenFun := GenFun.