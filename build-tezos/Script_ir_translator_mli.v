(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.
Require Tezos.Alpha_context_mli. Module Alpha_context := Alpha_context_mli.
Require Tezos.Michelson_v1_primitives.
Require Tezos.Script_expr_hash.
Require Tezos.Script_tc_errors.
Require Tezos.Script_typed_ir.

Import Alpha_context.

Import Script_tc_errors.

Reserved Notation "'eq".

Inductive eq_gadt : Set :=
| Eq : eq_gadt

where "'eq" := (fun (_ _ : Set) => eq_gadt).

Definition eq := 'eq.

Inductive ex_comparable_ty : Set :=
| Ex_comparable_ty : forall {a : Set},
  Script_typed_ir.comparable_ty a -> ex_comparable_ty.

Inductive ex_ty : Set :=
| Ex_ty : forall {a : Set}, Script_typed_ir.ty a -> ex_ty.

Inductive ex_stack_ty : Set :=
| Ex_stack_ty : forall {a : Set}, Script_typed_ir.stack_ty a -> ex_stack_ty.

Inductive ex_script : Set :=
| Ex_script : forall {a b : Set}, Script_typed_ir.script a b -> ex_script.

Module tc_context.
  Module Toplevel.
    Record record {storage_type param_type root_name
      legacy_create_contract_literal : Set} := {
      storage_type : storage_type;
      param_type : param_type;
      root_name : root_name;
      legacy_create_contract_literal : legacy_create_contract_literal }.
    Arguments record : clear implicits.
  End Toplevel.
  Definition Toplevel_skeleton := Toplevel.record.
End tc_context.

Reserved Notation "'tc_context.Toplevel".

Inductive tc_context : Set :=
| Lambda : tc_context
| Dip : forall {a : Set}, Script_typed_ir.stack_ty a -> tc_context -> tc_context
| Toplevel : forall {param sto : Set},
  'tc_context.Toplevel param sto -> tc_context

where "'tc_context.Toplevel" := (fun (t_param t_sto : Set) =>
  tc_context.Toplevel_skeleton (Script_typed_ir.ty t_sto)
    (Script_typed_ir.ty t_param) (option string) bool).

Module ConstructorRecordNotations_tc_context.
  Module tc_context.
    Definition Toplevel := 'tc_context.Toplevel.
  End tc_context.
End ConstructorRecordNotations_tc_context.
Import ConstructorRecordNotations_tc_context.

Module judgement.
  Module Failed.
    Record record {descr : Set} := {
      descr : descr }.
    Arguments record : clear implicits.
  End Failed.
  Definition Failed_skeleton := Failed.record.
End judgement.

Reserved Notation "'judgement.Failed".

Inductive judgement (bef : Set) : Set :=
| Typed : forall {aft : Set}, Script_typed_ir.descr bef aft -> judgement bef
| Failed : forall {aft : Set}, 'judgement.Failed aft bef -> judgement bef

where "'judgement.Failed" := (fun (t_aft t_bef : Set) =>
  judgement.Failed_skeleton
    ((Script_typed_ir.stack_ty t_aft -> Script_typed_ir.descr t_bef t_aft) *
      t_aft)).

Module ConstructorRecordNotations_judgement.
  Module judgement.
    Definition Failed := 'judgement.Failed.
  End judgement.
End ConstructorRecordNotations_judgement.
Import ConstructorRecordNotations_judgement.

Arguments Typed {_ _}.
Arguments Failed {_ _}.

Inductive unparsing_mode : Set :=
| Optimized : unparsing_mode
| Readable : unparsing_mode.

Definition type_logger :=
  Z -> list (Alpha_context.Script.expr * Alpha_context.Script.annot) ->
  list (Alpha_context.Script.expr * Alpha_context.Script.annot) -> unit.

Parameter empty_set : forall {a : Set},
  Script_typed_ir.comparable_ty a -> Script_typed_ir.set a.

Parameter set_fold : forall {acc elt : Set},
  (elt -> acc -> acc) -> Script_typed_ir.set elt -> acc -> acc.

Parameter set_update : forall {a : Set},
  a -> bool -> Script_typed_ir.set a -> Script_typed_ir.set a.

Parameter set_mem : forall {elt : Set}, elt -> Script_typed_ir.set elt -> bool.

Parameter set_size : forall {elt : Set},
  Script_typed_ir.set elt ->
  Alpha_context.Script_int.num Alpha_context.Script_int.n.

Parameter empty_map : forall {a b : Set},
  Script_typed_ir.comparable_ty a -> Script_typed_ir.map a b.

Parameter map_fold : forall {acc key value : Set},
  (key -> value -> acc -> acc) -> Script_typed_ir.map key value -> acc -> acc.

Parameter map_update : forall {a b : Set},
  a -> option b -> Script_typed_ir.map a b -> Script_typed_ir.map a b.

Parameter map_mem : forall {key value : Set},
  key -> Script_typed_ir.map key value -> bool.

Parameter map_get : forall {key value : Set},
  key -> Script_typed_ir.map key value -> option value.

Parameter map_key_ty : forall {a b : Set},
  Script_typed_ir.map a b -> Script_typed_ir.comparable_ty a.

Parameter map_size : forall {a b : Set},
  Script_typed_ir.map a b ->
  Alpha_context.Script_int.num Alpha_context.Script_int.n.

Parameter empty_big_map : forall {a b : Set},
  Script_typed_ir.comparable_ty a -> Script_typed_ir.ty b ->
  Script_typed_ir.big_map a b.

Parameter big_map_mem : forall {key value : Set},
  Alpha_context.context -> key -> Script_typed_ir.big_map key value ->
  Lwt.t (Error_monad.tzresult (bool * Alpha_context.context)).

Parameter big_map_get : forall {key value : Set},
  Alpha_context.context -> key -> Script_typed_ir.big_map key value ->
  Lwt.t (Error_monad.tzresult (option value * Alpha_context.context)).

Parameter big_map_update : forall {key value : Set},
  key -> option value -> Script_typed_ir.big_map key value ->
  Script_typed_ir.big_map key value.

Parameter ty_eq : forall {ta tb : Set},
  Alpha_context.context -> Script_typed_ir.ty ta -> Script_typed_ir.ty tb ->
  Error_monad.tzresult
    (eq (Script_typed_ir.ty ta) (Script_typed_ir.ty tb) * Alpha_context.context).

Parameter compare_comparable : forall {a : Set},
  Script_typed_ir.comparable_ty a -> a -> a -> Z.

Parameter parse_data : forall {a : Set},
  option type_logger -> Alpha_context.context -> bool -> Script_typed_ir.ty a ->
  Alpha_context.Script.node ->
  Lwt.t (Error_monad.tzresult (a * Alpha_context.context)).

Parameter unparse_data : forall {a : Set},
  Alpha_context.context -> unparsing_mode -> Script_typed_ir.ty a -> a ->
  Lwt.t
    (Error_monad.tzresult (Alpha_context.Script.node * Alpha_context.context)).

Parameter parse_instr : forall {bef : Set},
  option type_logger -> tc_context -> Alpha_context.context -> bool ->
  Alpha_context.Script.node -> Script_typed_ir.stack_ty bef ->
  Lwt.t (Error_monad.tzresult (judgement bef * Alpha_context.context)).

Parameter parse_ty :
  Alpha_context.context -> bool -> bool -> bool -> bool ->
  Alpha_context.Script.node ->
  Error_monad.tzresult (ex_ty * Alpha_context.context).

Parameter parse_packable_ty :
  Alpha_context.context -> bool -> Alpha_context.Script.node ->
  Error_monad.tzresult (ex_ty * Alpha_context.context).

Parameter unparse_ty : forall {a : Set},
  Alpha_context.context -> Script_typed_ir.ty a ->
  Lwt.t
    (Error_monad.tzresult (Alpha_context.Script.node * Alpha_context.context)).

Parameter parse_toplevel :
  bool -> Alpha_context.Script.expr ->
  Error_monad.tzresult
    (Alpha_context.Script.node * Alpha_context.Script.node *
      Alpha_context.Script.node * option string).

Parameter add_field_annot :
  option Script_typed_ir.field_annot -> option Script_typed_ir.var_annot ->
  Alpha_context.Script.node -> Alpha_context.Script.node.

Parameter typecheck_code :
  Alpha_context.context -> Alpha_context.Script.expr ->
  Lwt.t
    (Error_monad.tzresult (Script_tc_errors.type_map * Alpha_context.context)).

Parameter typecheck_data :
  option type_logger -> Alpha_context.context ->
  Alpha_context.Script.expr * Alpha_context.Script.expr ->
  Lwt.t (Error_monad.tzresult Alpha_context.context).

Parameter parse_script :
  option type_logger -> Alpha_context.context -> bool ->
  Alpha_context.Script.t ->
  Lwt.t (Error_monad.tzresult (ex_script * Alpha_context.context)).

Parameter unparse_script : forall {a b : Set},
  Alpha_context.context -> unparsing_mode -> Script_typed_ir.script a b ->
  Lwt.t (Error_monad.tzresult (Alpha_context.Script.t * Alpha_context.context)).

Parameter parse_contract : forall {a : Set},
  bool -> Alpha_context.context -> Alpha_context.Script.location ->
  Script_typed_ir.ty a -> Alpha_context.Contract.t -> string ->
  Lwt.t
    (Error_monad.tzresult
      (Alpha_context.context * Script_typed_ir.typed_contract a)).

Parameter parse_contract_for_script : forall {a : Set},
  bool -> Alpha_context.context -> Alpha_context.Script.location ->
  Script_typed_ir.ty a -> Alpha_context.Contract.t -> string ->
  Lwt.t
    (Error_monad.tzresult
      (Alpha_context.context * option (Script_typed_ir.typed_contract a))).

Parameter find_entrypoint : forall {t : Set},
  Script_typed_ir.ty t -> option string -> string ->
  Error_monad.tzresult
    ((Alpha_context.Script.node -> Alpha_context.Script.node) * ex_ty).

Parameter Entrypoints_map : {t : _ & S.MAP.signature string t}.

Parameter list_entrypoints : forall {t : Set},
  Script_typed_ir.ty t -> Alpha_context.context -> option string ->
  Error_monad.tzresult
    (list (list Michelson_v1_primitives.prim) *
      (|Entrypoints_map|).(S.MAP.t)
        (list Michelson_v1_primitives.prim * Alpha_context.Script.node)).

Parameter pack_data : forall {a : Set},
  Alpha_context.context -> Script_typed_ir.ty a -> a ->
  Lwt.t (Error_monad.tzresult (MBytes.t * Alpha_context.context)).

Parameter hash_data : forall {a : Set},
  Alpha_context.context -> Script_typed_ir.ty a -> a ->
  Lwt.t (Error_monad.tzresult (Script_expr_hash.t * Alpha_context.context)).

Parameter big_map_ids : Set.

Parameter no_big_map_id : big_map_ids.

Parameter collect_big_maps : forall {a : Set},
  Alpha_context.context -> Script_typed_ir.ty a -> a ->
  Lwt.t (Error_monad.tzresult (big_map_ids * Alpha_context.context)).

Parameter list_of_big_map_ids : big_map_ids -> list Z.t.

Parameter extract_big_map_diff : forall {a : Set},
  Alpha_context.context -> unparsing_mode -> bool -> big_map_ids ->
  big_map_ids -> Script_typed_ir.ty a -> a ->
  Lwt.t
    (Error_monad.tzresult
      (a * option Alpha_context.Contract.big_map_diff * Alpha_context.context)).
