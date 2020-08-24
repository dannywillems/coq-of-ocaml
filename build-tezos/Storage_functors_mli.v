(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Raw_context.
Require Tezos.Storage_description.
Require Tezos.Storage_sigs.

Import Storage_sigs.

Parameter Registered : {_ : unit & REGISTER.signature}.

Parameter Ghost : {_ : unit & REGISTER.signature}.

Parameter Make_subcontext :
  forall (R : {_ : unit & REGISTER.signature}),
    (forall (C : {t : Set & Raw_context.T.signature (t := t)}),
      (forall (N : {_ : unit & NAME.signature}),
        {_ : unit & Raw_context.T.signature (t := (|C|).(Raw_context.T.t))})).

Parameter Make_single_data_storage :
  forall (R : {_ : unit & REGISTER.signature}),
    (forall (C : {t : Set & Raw_context.T.signature (t := t)}),
      (forall (N : {_ : unit & NAME.signature}),
        (forall (V : {t : Set & VALUE.signature (t := t)}),
          {_ : unit &
            Single_data_storage.signature (t := (|C|).(Raw_context.T.t))
              (value := (|V|).(Storage_sigs.VALUE.t))}))).

Module INDEX.
  Record signature {t : Set} {ipath : Set -> Set} : Set := {
    t := t;
    path_length : int;
    to_path : t -> list string -> list string;
    of_path : list string -> option t;
    ipath := ipath;
    args : unit -> Storage_description.args;
    infer_ipath : forall {a : Set}, ipath a -> a -> a;
  }.
End INDEX.

Parameter Pair :
  forall (I1 :
    {'[t, ipath] : [Set ** Set -> Set] &
      INDEX.signature (t := t) (ipath := ipath)}),
    (forall (I2 :
      {'[t, ipath] : [Set ** Set -> Set] &
        INDEX.signature (t := t) (ipath := ipath)}),
      {ipath : Set -> Set &
        INDEX.signature (t := ((|I1|).(INDEX.t) * (|I2|).(INDEX.t)))
          (ipath := ipath)}).

Parameter Make_data_set_storage :
  forall (C : {t : Set & Raw_context.T.signature (t := t)}),
    (forall (I :
      {'[t, ipath] : [Set ** Set -> Set] &
        INDEX.signature (t := t) (ipath := ipath)}),
      {_ : unit &
        Data_set_storage.signature (t := (|C|).(Raw_context.T.t))
          (elt := (|I|).(INDEX.t))}).

Parameter Make_indexed_data_storage :
  forall (C : {t : Set & Raw_context.T.signature (t := t)}),
    (forall (I :
      {'[t, ipath] : [Set ** Set -> Set] &
        INDEX.signature (t := t) (ipath := ipath)}),
      (forall (V : {t : Set & VALUE.signature (t := t)}),
        {_ : unit &
          Indexed_data_storage.signature (t := (|C|).(Raw_context.T.t))
            (key := (|I|).(INDEX.t)) (value := (|V|).(Storage_sigs.VALUE.t))})).

Parameter Make_indexed_carbonated_data_storage :
  forall (C : {t : Set & Raw_context.T.signature (t := t)}),
    (forall (I :
      {'[t, ipath] : [Set ** Set -> Set] &
        INDEX.signature (t := t) (ipath := ipath)}),
      (forall (V : {t : Set & VALUE.signature (t := t)}),
        {_ : unit &
          Non_iterable_indexed_carbonated_data_storage.signature
            (t := (|C|).(Raw_context.T.t)) (key := (|I|).(INDEX.t))
            (value := (|V|).(Storage_sigs.VALUE.t))})).

Parameter Make_indexed_data_snapshotable_storage :
  forall (C : {t : Set & Raw_context.T.signature (t := t)}),
    (forall (Snapshot :
      {'[t, ipath] : [Set ** Set -> Set] &
        INDEX.signature (t := t) (ipath := ipath)}),
      (forall (I :
        {'[t, ipath] : [Set ** Set -> Set] &
          INDEX.signature (t := t) (ipath := ipath)}),
        (forall (V : {t : Set & VALUE.signature (t := t)}),
          {_ : unit &
            Indexed_data_snapshotable_storage.signature
              (snapshot := (|Snapshot|).(INDEX.t)) (key := (|I|).(INDEX.t))
              (t := (|C|).(Raw_context.T.t))
              (value := (|V|).(Storage_sigs.VALUE.t))}))).

Parameter Make_indexed_subcontext :
  forall (C : {t : Set & Raw_context.T.signature (t := t)}),
    (forall (I :
      {'[t, ipath] : [Set ** Set -> Set] &
        INDEX.signature (t := t) (ipath := ipath)}),
      {_ : unit &
        Indexed_raw_context.signature (t := (|C|).(Raw_context.T.t))
          (key := (|I|).(INDEX.t))
          (ipath := (fun (a : Set) => (|I|).(INDEX.ipath) a))}).

Module WRAPPER.
  Record signature {t key : Set} : Set := {
    t := t;
    key := key;
    wrap : t -> key;
    unwrap : key -> option t;
  }.
End WRAPPER.

Parameter Wrap_indexed_data_storage :
  forall (C :
    {'[t, key, value] : [Set ** Set ** Set] &
      Indexed_data_storage.signature (t := t) (key := key) (value := value)}),
    (forall (K :
      {t : Set &
        WRAPPER.signature (t := t)
          (key := (|C|).(Storage_sigs.Indexed_data_storage.key))}),
      {_ : unit &
        Indexed_data_storage.signature
          (t := (|C|).(Storage_sigs.Indexed_data_storage.t))
          (key := (|K|).(WRAPPER.t))
          (value := (|C|).(Storage_sigs.Indexed_data_storage.value))}).