Require Export ZArith.
Require Export Ascii.
Require Export String.
Require Export List.
Require Export Program.Basics.
Require Export Classes.SetoidDec.

Local Open Scope Z_scope.
Import ListNotations.
Set Implicit Arguments.

Definition sum_assoc_left (A B C : Type) (x : A + (B + C)) : (A + B) + C :=
  match x with
  | inl x => inl (inl x)
  | inr (inl x) => inl (inr x)
  | inr (inr x) => inr x
  end.

Module Effect.
  Record t := make {
    S : Type;
    E : Type }.
  
  Definition nil : t := {|
    S := unit;
    E := Empty_set |}.
  
  Definition add (e1 e2 : t) : t := {|
    S := S e1 * S e2;
    E := E e1 + E e2 |}.
  
  Fixpoint of_list (es : list t) : t :=
    match es with
    | [] => nil
    | e :: es => add e (of_list es)
    end.
  
  Definition state (es : list t) : Type :=
    S (of_list es).
  
  Definition error (es : list t) : Type :=
    E (of_list es).
  
  Module Ebs.
    Fixpoint domain (ebs : list (t * bool)) : list t :=
      match ebs with
      | [] => []
      | (e, _) :: ebs => e :: domain ebs
      end.
    
    Fixpoint sub (ebs : list (t * bool)) : list t :=
      match ebs with
      | [] => []
      | (_, false) :: ebs => sub ebs
      | (e, true) :: ebs => e :: sub ebs
      end.
    
    Fixpoint negsub (ebs : list (t * bool)) : list t :=
      match ebs with
      | [] => []
      | (_, true) :: ebs => negsub ebs
      | (e, false) :: ebs => e :: negsub ebs
      end.
    
    Fixpoint filter_state (ebs : list (t * bool))
      (s : state (domain ebs)) {struct ebs}
      : state (sub ebs).
      destruct ebs as [|[e b] ebs].
      - exact s.
      - destruct b; simpl in *.
        + exact (fst s, filter_state ebs (snd s)).
        + exact (filter_state ebs (snd s)).
    Defined.
    
    Fixpoint expand_exception (ebs : list (t * bool))
      (err : error (sub ebs)) {struct ebs}
      : error (domain ebs).
      destruct ebs as [|[e b] ebs].
      - exact err.
      - destruct b; simpl in *.
        + exact (match err with
          | inl err => inl err
          | inr err => inr (expand_exception ebs err)
          end).
        + exact (inr (expand_exception ebs err)).
    Defined.
    
    Fixpoint expand_state (ebs : list (t * bool))
      (s1 : state (sub ebs)) (s2 : state (domain ebs))
      {struct ebs} : state (domain ebs).
      destruct ebs as [|[e b] ebs].
      - exact s1.
      - destruct b; simpl in *.
        + exact (fst s1, expand_state ebs (snd s1) (snd s2)).
        + exact (fst s2, expand_state ebs s1 (snd s2)).
    Defined.
  End Ebs.
  
  Module Filter.
    Definition S (e : t) : t :=
      make (Effect.S e) Empty_set.
    
    Fixpoint states (ebs : list (t * bool)) : list t :=
      match ebs with
      | [] => []
      | (e, false) :: ebs => e :: states ebs
      | (e, true) :: ebs => S e :: states ebs
      end.
  End Filter.
End Effect.

Definition M (es : list Effect.t) (A : Type) : Type :=
  Effect.state es -> (A + Effect.error es) * Effect.state es.

Definition ret {es : list Effect.t} {A : Type} (x : A) : M es A :=
  fun s => (inl x, s).

Definition unret {A : Type} (x: M [] A) : A :=
  match x tt with
  | (inl x, _) => x
  | (inr err, _) => match err with end
  end.

Definition bind {es : list Effect.t} {A B : Type}
  (x : M es A) (f : A -> M es B) : M es B :=
  fun s =>
    let (x, s) := x s in
    match x with
    | inl x => f x s
    | inr e => (inr e, s)
    end.

Notation "'let!' X ':=' A 'in' B" := (bind A (fun X => B))
  (at level 200, X ident, A at level 100, B at level 200).

Definition lift {A : Type} (es : list Effect.t) (bs : string)
  (x : M _ A) : M _ A :=
  let aux (ebs : list (Effect.t * bool)) (x : M (Effect.Ebs.sub ebs) A)
    : M (Effect.Ebs.domain ebs) A :=
    fun s =>
      let (r, s') := x (Effect.Ebs.filter_state ebs s) in
      let s := Effect.Ebs.expand_state ebs s' s in
      match r with
      | inl x => (inl x, s)
      | inr err => (inr (Effect.Ebs.expand_exception ebs err), s)
      end in
  let fix bool_list (s : string) : list bool :=
    match s with
    | EmptyString => []
    | String "0" s => false :: bool_list s
    | String _ s => true :: bool_list s
    end in
  aux (List.combine es (bool_list bs)) x.

Module Run.
  Fixpoint errors_input (ebs : list (Effect.t * bool))
    (s : Effect.state (Effect.Filter.states ebs)) {struct ebs}
    : Effect.state (Effect.Ebs.domain ebs).
    destruct ebs as [|[e b] ebs].
    - exact s.
    - destruct b; exact (
        let (s, ss) := s in
        (s, errors_input _ ss)).
  Defined.

  Fixpoint errors_output (ebs : list (Effect.t * bool))
    (s : Effect.state (Effect.Ebs.domain ebs)) {struct ebs}
    : Effect.state (Effect.Filter.states ebs).
    destruct ebs as [|[e b] ebs].
    - exact s.
    - destruct b; exact (
        let (s, ss) := s in
        (s, errors_output _ ss)).
  Defined.

  Fixpoint errors_error (ebs : list (Effect.t * bool))
    (err : Effect.error (Effect.Ebs.domain ebs)) {struct ebs}
    : Effect.error (Effect.Ebs.sub ebs) + Effect.error (Effect.Filter.states ebs).
    destruct ebs as [|(e, b) ebs].
    - destruct err.
    - destruct err as [err | err].
      + destruct b; [exact (inl (inl err)) | exact (inr (inl err))].
      + destruct (errors_error _ err) as [err' | err'];
          [apply inl | apply inr]; destruct b; try apply inr; exact err'.
  Defined.

  Definition errors {A : Type} (ebs : list (Effect.t * bool))
    (x : M (Effect.Ebs.domain ebs) A)
    : M (Effect.Filter.states ebs) (A + Effect.error (Effect.Ebs.sub ebs)) :=
    fun s =>
      let (r, s) := x (errors_input _ s) in
      (match r with
      | inl x => inl (inl x)
      | inr err => sum_assoc_left (inr (errors_error _ err))
      end, errors_output _ s).
End Run.

Module Exception.
  Fixpoint remove_nth (es : list Effect.t) (n : nat) : list Effect.t :=
    match es with
    | [] => []
    | e :: es =>
      match n with
      | O => es
      | S n => e :: remove_nth es n
      end
    end.
  
  Definition nth_is_stateless (es : list Effect.t) (n : nat) : Type :=
    match List.nth_error es n with
    | Some e => Effect.S e
    | None => unit
    end.
  
  Fixpoint input (es : list Effect.t) (n : nat) (tt' : nth_is_stateless es n)
    (s : Effect.state (remove_nth es n)) {struct es} : Effect.state es.
    destruct es as [|e es].
    - exact s.
    - destruct n as [|n].
      + exact (tt', s).
      + refine (fst s, input es n tt' (snd s)).
  Defined.
  
  Fixpoint output (es : list Effect.t) (n : nat) (s : Effect.state es)
    {struct es} : Effect.state (remove_nth es n).
    destruct es as [|e es].
    - exact s.
    - destruct n as [|n].
      + exact (snd s).
      + exact (fst s, output _ _ (snd s)).
  Defined.
  
  Fixpoint error (es : list Effect.t) (n : nat) (err : Effect.error es)
    {struct es}
    : Effect.E (nth n es Effect.nil) + Effect.error (remove_nth es n).
    destruct es as [|e es].
    - destruct err.
    - destruct n as [|n].
      + exact err.
      + refine (
          match err with
          | inl err => inr (inl err)
          | inr err =>
            match error _ _ err with
            | inl err => inl err
            | inr err => inr (inr err)
            end
          end).
  Defined.
  
  Definition run {A : Type} {es : list Effect.t} (n : nat)
    (x : M es A) (tt' : nth_is_stateless es n)
    : M (remove_nth es n) (A + Effect.E (List.nth n es Effect.nil)) :=
    fun s =>
      let (r, s) := x (input _ _ tt' s) in
      (match r with
      | inl x => inl (inl x)
      | inr err => sum_assoc_left (inr (error _ _ err))
      end, output _ _ s).
End Exception.

Definition IO := Effect.make (list string * list string) Empty_set.

Definition Counter := Effect.make nat Empty_set.

Definition NonTermination := Effect.make unit unit.

Definition read_counter (_ : unit) : M [Counter] nat :=
  fun s => (inl (fst s), s).

Definition not_terminated {A : Type} (_ : unit) : M [NonTermination] A :=
  fun s => (inr (inl tt), s).

(* TODO: add floats, add the different integer types (int32, int64, ...). *)
Module OCaml.
  Instance Z_eqdec : EqDec (A := Z) _ := Z.eq_dec.
  
  Definition Match_failure := Effect.make unit (string * Z * Z).
   Definition raise_Match_failure {A : Type} (x : string * Z * Z)
    : M [ Match_failure ] A :=
    fun s => (inr (inl x), s).
  
  Definition Assert_failure := Effect.make unit (string * Z * Z).
  Definition raise_Assert_failure {A : Type} (x : string * Z * Z)
    : M [ Assert_failure ] A :=
    fun s => (inr (inl x), s).
  
  Definition Invalid_argument := Effect.make unit string.
  Definition raise_Invalid_argument {A : Type} (x : string)
    : M [ Invalid_argument ] A :=
    fun s => (inr (inl x), s).

  Definition Failure := Effect.make unit string.
  Definition raise_Failure {A : Type} (x : string)
    : M [ Failure ] A :=
    fun s => (inr (inl x), s).
  
  Definition Not_found := Effect.make unit unit.
  Definition raise_Not_found {A : Type} (x : unit)
    : M [ Not_found ] A :=
    fun s => (inr (inl x), s).

  Definition Out_of_memory := Effect.make unit unit.
  Definition raise_Out_of_memory {A : Type} (x : unit)
    : M [ Out_of_memory ] A :=
    fun s => (inr (inl x), s).

  Definition Stack_overflow := Effect.make unit unit.
  Definition raise_Stack_overflow {A : Type} (x : unit)
    : M [ Stack_overflow ] A :=
    fun s => (inr (inl x), s).

  Definition Sys_error := Effect.make unit string.
  Definition raise_Sys_error {A : Type} (x : string)
    : M [ Sys_error ] A :=
    fun s => (inr (inl x), s).
  
  Definition End_of_file := Effect.make unit unit.
  Definition raise_End_of_file {A : Type} (x : unit)
    : M [ End_of_file ] A :=
    fun s => (inr (inl x), s).
  
  Definition Division_by_zero := Effect.make unit unit.
  Definition raise_Division_by_zero {A : Type} (x : unit)
    : M [ Division_by_zero ] A :=
    fun s => (inr (inl x), s).

  Definition Sys_blocked_io := Effect.make unit unit.
  Definition raise_Sys_blocked_io {A : Type} (x : unit)
    : M [ Sys_blocked_io ] A :=
    fun s => (inr (inl x), s).

  Definition Undefined_recursive_module := Effect.make unit (string * Z * Z).
  Definition raise_Undefined_recursive_module {A : Type} (x : string * Z * Z)
    : M [ Undefined_recursive_module ] A :=
    fun s => (inr (inl x), s).
  
  (** OCaml functions are converted to their Coq's counter parts when it is
      possible. *)
  Module Pervasives.
    (** * Exceptions *)
    Definition invalid_arg {A : Type} (message : string)
      : M [Invalid_argument] A :=
      raise_Invalid_argument message.

    Definition failwith {A : Type} (message : string)
      : M [Failure] A :=
      raise_Failure message.
    
    Definition Exit := Effect.make unit unit.
    Definition raise_Exit {A : Type} (x : unit) : M [ Exit ] A :=
      fun s => (inr (inl x), s).
    
    (** * Comparisons *)
    
    (** * Boolean operations *)
    
    (** * Composition operators *)
    Definition reverse_apply {A B : Type} (x : A) (f : A -> B) : B :=
      f x.
    
    (** * Integer arithmetic *)
    
    (** * Bitwise operations *)
    
    (** * Floating-point arithmetic *)
    (* TODO *)
    
    (** * String operations *)
    
    (** * Character operations *)
    Definition int_of_char (c : ascii) : Z :=
      Z.of_nat (nat_of_ascii c).

    (* TODO: raise Invalid_argument "char_of_int" if the argument is outside the range 0-255. *)
    Definition char_of_int (n : Z) : ascii :=
      ascii_of_nat (Z.to_nat n).
    
    (** * Unit operations *)
    Definition ignore {A : Type} (_ : A) : unit :=
      tt.
    
    (** * String conversion functions *)
    Definition string_of_bool (b : bool) : string :=
      if b then
        "true" % string
      else
        "false" % string.
    
    (* TODO *)
    Definition bool_of_string (s : string) : bool :=
      false.
    
    (* TODO *)
    Definition string_of_int (n : Z) : string :=
      "0".
    
    (* TODO *)
    Definition int_of_string (s : string) : Z :=
      0.
    
    (** * Pair operations *)
    
    (** * List operations *)
    
    (** * Input/output *)
    (* TODO: add channels. *)
    
    (** * Output functions on standard output *)
    Definition print_string (message : string) : M [IO] unit :=
      fun s =>
        match s with
        | ((stream_i, stream_o), _) =>
          (inl tt, ((stream_i, message :: stream_o), tt))
        end.
    
    Definition print_char (c : ascii) : M [IO] unit :=
      print_string (String.String c String.EmptyString).
    
    Definition print_int (n : Z) : M [IO] unit :=
      print_string (string_of_int n).
    
    Definition print_newline (_ : unit) : M [IO] unit :=
      print_char "010" % char.
    
    Definition print_endline (message : string) : M [IO] unit :=
      let! _ := print_string message in
      print_newline tt.
    
    (** * Output functions on standard error *)
    (* TODO: do it on the error channel. *)
    Definition prerr_string (message : string) : M [IO] unit :=
      print_string message.
    
    Definition prerr_char (c : ascii) : M [IO] unit :=
      print_char c.
    
    Definition prerr_int (n : Z) : M [IO] unit :=
      print_int n.
    
    Definition prerr_newline (_ : unit) : M [IO] unit :=
      print_newline tt.
    
    Definition prerr_endline (message : string) : M [IO] unit :=
      print_endline message.
    
    (** * Input functions on standard input *)
    Definition read_line (_ : unit) : M [IO] string :=
      fun s =>
        match s with
        | ((stream_i, stream_o), _) =>
          match stream_i with
          | [] => (inl "" % string, s) (* We could raise an [End_of_file] exception. *)
          | message :: stream_i => (inl message, ((stream_i, stream_o), tt))
          end
        end.
    
    Definition read_int (_ : unit) : M [IO] Z :=
      let! s := read_line tt in
      ret (int_of_string s).
    
    (** * General output functions *)
    (* TODO *)
    
    (** * General input functions *)
    (* TODO *)
    
    (** * Operations on large files *)
    (* TODO *)
    
    (** * References *)
    (* No first-class reference for now. *)
    
    (** * Operations on format strings *)
    (* TODO *)
    
    (** * Program termination *)
    (* TODO *)
  End Pervasives.

  Module List.
    (** The concatenation of lists with an implicit parameter. *)
    Definition app {A : Type} (l1 l2 : list A) : list A :=
      app l1 l2.
  End List.

  Module String.
    Definition length (s : string) : Z :=
      Z.of_nat (String.length s).
    
    (* TODO: raise an exception if n < 0. *)
    Definition get (s : string) (n : Z) : ascii :=
      match String.get (Z.to_nat n) s with
      | None => "?" % char
      | Some c => c
      end.
    
    Fixpoint _make (n : nat) (c : ascii) : string :=
      match n with
      | O => EmptyString
      | S n => String c (_make n c)
      end.
    
    (* TODO: raise an exception if n < 0. *)
    Definition make (n : Z) (c : ascii) : string :=
      _make (Z.to_nat n) c.
    
    (* TODO *)
    Definition sub (s : string) (start : Z) (length : Z) : string :=
      s.
    
    (* TODO *)
    Definition escaped (s : string) : string :=
      s.
  End String.
End OCaml.

