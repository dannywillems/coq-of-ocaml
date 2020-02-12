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

Import Alpha_context.

Import Alpha_context.Script_int.

Inductive var_annot : Set :=
| Var_annot : string -> var_annot.

Inductive type_annot : Set :=
| Type_annot : string -> type_annot.

Inductive field_annot : Set :=
| Field_annot : string -> field_annot.

Definition address := Alpha_context.Contract.t * string.

Definition pair (a b : Set) := a * b.

Inductive union (a b : Set) : Set :=
| L : a -> union a b
| R : b -> union a b.

Arguments L {_ _}.
Arguments R {_ _}.

Inductive comb : Set :=
| Comb : comb.

Inductive leaf : Set :=
| Leaf : leaf.

Reserved Notation "'comparable_struct".

Inductive comparable_struct_gadt : Set :=
| Int_key : option type_annot -> comparable_struct_gadt
| Nat_key : option type_annot -> comparable_struct_gadt
| String_key : option type_annot -> comparable_struct_gadt
| Bytes_key : option type_annot -> comparable_struct_gadt
| Mutez_key : option type_annot -> comparable_struct_gadt
| Bool_key : option type_annot -> comparable_struct_gadt
| Key_hash_key : option type_annot -> comparable_struct_gadt
| Timestamp_key : option type_annot -> comparable_struct_gadt
| Address_key : option type_annot -> comparable_struct_gadt
| Pair_key :
  comparable_struct_gadt * option field_annot ->
  comparable_struct_gadt * option field_annot -> option type_annot ->
  comparable_struct_gadt

where "'comparable_struct" := (fun (_ _ : Set) => comparable_struct_gadt).

Definition comparable_struct := 'comparable_struct.

Definition comparable_ty (a : Set) := comparable_struct a comb.

Module Boxed_set.
  Record signature {elt OPS_t : Set} := {
    elt := elt;
    elt_ty : comparable_ty elt;
    OPS : S.SET.signature elt OPS_t;
    boxed : OPS.(S.SET.t);
    size : Z;
  }.
  Arguments signature : clear implicits.
End Boxed_set.

Definition set (elt : Set) := {OPS_t : _ & Boxed_set.signature elt OPS_t}.

Module Boxed_map.
  Record signature {key value : Set} {OPS_t : Set -> Set} := {
    key := key;
    value := value;
    key_ty : comparable_ty key;
    OPS : S.MAP.signature key OPS_t;
    boxed : OPS.(S.MAP.t) value * Z;
  }.
  Arguments signature : clear implicits.
End Boxed_map.

Definition map (key value : Set) :=
  {OPS_t : _ & Boxed_map.signature key value OPS_t}.

Definition operation :=
  Alpha_context.packed_internal_operation *
    option Alpha_context.Contract.big_map_diff.

Module script.
  Record record {code arg_type storage storage_type root_name : Set} := Build {
    code : code;
    arg_type : arg_type;
    storage : storage;
    storage_type : storage_type;
    root_name : root_name }.
  Arguments record : clear implicits.
  Definition with_code {t_code t_arg_type t_storage t_storage_type t_root_name}
    code (r : record t_code t_arg_type t_storage t_storage_type t_root_name) :=
    Build t_code t_arg_type t_storage t_storage_type t_root_name code
      r.(arg_type) r.(storage) r.(storage_type) r.(root_name).
  Definition with_arg_type
    {t_code t_arg_type t_storage t_storage_type t_root_name} arg_type
    (r : record t_code t_arg_type t_storage t_storage_type t_root_name) :=
    Build t_code t_arg_type t_storage t_storage_type t_root_name r.(code)
      arg_type r.(storage) r.(storage_type) r.(root_name).
  Definition with_storage
    {t_code t_arg_type t_storage t_storage_type t_root_name} storage
    (r : record t_code t_arg_type t_storage t_storage_type t_root_name) :=
    Build t_code t_arg_type t_storage t_storage_type t_root_name r.(code)
      r.(arg_type) storage r.(storage_type) r.(root_name).
  Definition with_storage_type
    {t_code t_arg_type t_storage t_storage_type t_root_name} storage_type
    (r : record t_code t_arg_type t_storage t_storage_type t_root_name) :=
    Build t_code t_arg_type t_storage t_storage_type t_root_name r.(code)
      r.(arg_type) r.(storage) storage_type r.(root_name).
  Definition with_root_name
    {t_code t_arg_type t_storage t_storage_type t_root_name} root_name
    (r : record t_code t_arg_type t_storage t_storage_type t_root_name) :=
    Build t_code t_arg_type t_storage t_storage_type t_root_name r.(code)
      r.(arg_type) r.(storage) r.(storage_type) root_name.
End script.
Definition script_skeleton := script.record.

Module lambda.
  Record record {lam : Set} := Build {
    lam : lam }.
  Arguments record : clear implicits.
  Definition with_lam {t_lam} lam (r : record t_lam) :=
    Build t_lam lam.
End lambda.
Definition lambda_skeleton := lambda.record.

Module descr.
  Record record {loc bef aft instr : Set} := Build {
    loc : loc;
    bef : bef;
    aft : aft;
    instr : instr }.
  Arguments record : clear implicits.
  Definition with_loc {t_loc t_bef t_aft t_instr} loc
    (r : record t_loc t_bef t_aft t_instr) :=
    Build t_loc t_bef t_aft t_instr loc r.(bef) r.(aft) r.(instr).
  Definition with_bef {t_loc t_bef t_aft t_instr} bef
    (r : record t_loc t_bef t_aft t_instr) :=
    Build t_loc t_bef t_aft t_instr r.(loc) bef r.(aft) r.(instr).
  Definition with_aft {t_loc t_bef t_aft t_instr} aft
    (r : record t_loc t_bef t_aft t_instr) :=
    Build t_loc t_bef t_aft t_instr r.(loc) r.(bef) aft r.(instr).
  Definition with_instr {t_loc t_bef t_aft t_instr} instr
    (r : record t_loc t_bef t_aft t_instr) :=
    Build t_loc t_bef t_aft t_instr r.(loc) r.(bef) r.(aft) instr.
End descr.
Definition descr_skeleton := descr.record.

Module big_map.
  Record record {id diff key_type value_type : Set} := Build {
    id : id;
    diff : diff;
    key_type : key_type;
    value_type : value_type }.
  Arguments record : clear implicits.
  Definition with_id {t_id t_diff t_key_type t_value_type} id
    (r : record t_id t_diff t_key_type t_value_type) :=
    Build t_id t_diff t_key_type t_value_type id r.(diff) r.(key_type)
      r.(value_type).
  Definition with_diff {t_id t_diff t_key_type t_value_type} diff
    (r : record t_id t_diff t_key_type t_value_type) :=
    Build t_id t_diff t_key_type t_value_type r.(id) diff r.(key_type)
      r.(value_type).
  Definition with_key_type {t_id t_diff t_key_type t_value_type} key_type
    (r : record t_id t_diff t_key_type t_value_type) :=
    Build t_id t_diff t_key_type t_value_type r.(id) r.(diff) key_type
      r.(value_type).
  Definition with_value_type {t_id t_diff t_key_type t_value_type} value_type
    (r : record t_id t_diff t_key_type t_value_type) :=
    Build t_id t_diff t_key_type t_value_type r.(id) r.(diff) r.(key_type)
      value_type.
End big_map.
Definition big_map_skeleton := big_map.record.

Reserved Notation "'end_of_stack".
Reserved Notation "'ty".
Reserved Notation "'stack_ty".
Reserved Notation "'typed_contract".
Reserved Notation "'big_map".
Reserved Notation "'instr".
Reserved Notation "'stack_prefix_preservation_witness".
Reserved Notation "'descr".
Reserved Notation "'lambda".
Reserved Notation "'script".

Inductive ty_gadt : Set :=
| Unit_t : option type_annot -> ty_gadt
| Int_t : option type_annot -> ty_gadt
| Nat_t : option type_annot -> ty_gadt
| Signature_t : option type_annot -> ty_gadt
| String_t : option type_annot -> ty_gadt
| Bytes_t : option type_annot -> ty_gadt
| Mutez_t : option type_annot -> ty_gadt
| Key_hash_t : option type_annot -> ty_gadt
| Key_t : option type_annot -> ty_gadt
| Timestamp_t : option type_annot -> ty_gadt
| Address_t : option type_annot -> ty_gadt
| Bool_t : option type_annot -> ty_gadt
| Pair_t :
  ty_gadt * option field_annot * option var_annot ->
  ty_gadt * option field_annot * option var_annot -> option type_annot ->
  bool -> ty_gadt
| Union_t :
  ty_gadt * option field_annot -> ty_gadt * option field_annot ->
  option type_annot -> bool -> ty_gadt
| Lambda_t : ty_gadt -> ty_gadt -> option type_annot -> ty_gadt
| Option_t : ty_gadt -> option type_annot -> bool -> ty_gadt
| List_t : ty_gadt -> option type_annot -> bool -> ty_gadt
| Set_t : forall {v : Set}, comparable_ty v -> option type_annot -> ty_gadt
| Map_t : forall {k : Set},
  comparable_ty k -> ty_gadt -> option type_annot -> bool -> ty_gadt
| Big_map_t : forall {k : Set},
  comparable_ty k -> ty_gadt -> option type_annot -> ty_gadt
| Contract_t : ty_gadt -> option type_annot -> ty_gadt
| Operation_t : option type_annot -> ty_gadt
| Chain_id_t : option type_annot -> ty_gadt

with stack_ty_gadt : Set :=
| Item_t : forall {ty : Set},
  'ty ty -> stack_ty_gadt -> option var_annot -> stack_ty_gadt
| Empty_t : stack_ty_gadt

with instr_gadt : Set :=
| Drop : instr_gadt
| Dup : instr_gadt
| Swap : instr_gadt
| Const : forall {ty : Set}, ty -> instr_gadt
| Cons_pair : instr_gadt
| Car : instr_gadt
| Cdr : instr_gadt
| Cons_some : instr_gadt
| Cons_none : forall {a : Set}, 'ty a -> instr_gadt
| If_none : forall {a aft bef : Set},
  'descr bef aft -> 'descr (a * bef) aft -> instr_gadt
| Left : instr_gadt
| Right : instr_gadt
| If_left : forall {aft bef l r : Set},
  'descr (l * bef) aft -> 'descr (r * bef) aft -> instr_gadt
| Cons_list : instr_gadt
| Nil : instr_gadt
| If_cons : forall {a aft bef : Set},
  'descr (a * (list a * bef)) aft -> 'descr bef aft -> instr_gadt
| List_map : forall {a b rest : Set}, 'descr (a * rest) (b * rest) -> instr_gadt
| List_iter : forall {a rest : Set}, 'descr (a * rest) rest -> instr_gadt
| List_size : instr_gadt
| Empty_set : forall {a : Set}, comparable_ty a -> instr_gadt
| Set_iter : forall {a rest : Set}, 'descr (a * rest) rest -> instr_gadt
| Set_mem : instr_gadt
| Set_update : instr_gadt
| Set_size : instr_gadt
| Empty_map : forall {a v : Set}, comparable_ty a -> 'ty v -> instr_gadt
| Map_map : forall {a r rest v : Set},
  'descr ((a * v) * rest) (r * rest) -> instr_gadt
| Map_iter : forall {a rest v : Set}, 'descr ((a * v) * rest) rest -> instr_gadt
| Map_mem : instr_gadt
| Map_get : instr_gadt
| Map_update : instr_gadt
| Map_size : instr_gadt
| Empty_big_map : forall {a v : Set}, comparable_ty a -> 'ty v -> instr_gadt
| Big_map_mem : instr_gadt
| Big_map_get : instr_gadt
| Big_map_update : instr_gadt
| Concat_string : instr_gadt
| Concat_string_pair : instr_gadt
| Slice_string : instr_gadt
| String_size : instr_gadt
| Concat_bytes : instr_gadt
| Concat_bytes_pair : instr_gadt
| Slice_bytes : instr_gadt
| Bytes_size : instr_gadt
| Add_seconds_to_timestamp : instr_gadt
| Add_timestamp_to_seconds : instr_gadt
| Sub_timestamp_seconds : instr_gadt
| Diff_timestamps : instr_gadt
| Add_tez : instr_gadt
| Sub_tez : instr_gadt
| Mul_teznat : instr_gadt
| Mul_nattez : instr_gadt
| Ediv_teznat : instr_gadt
| Ediv_tez : instr_gadt
| Or : instr_gadt
| And : instr_gadt
| Xor : instr_gadt
| Not : instr_gadt
| Is_nat : instr_gadt
| Neg_nat : instr_gadt
| Neg_int : instr_gadt
| Abs_int : instr_gadt
| Int_nat : instr_gadt
| Add_intint : instr_gadt
| Add_intnat : instr_gadt
| Add_natint : instr_gadt
| Add_natnat : instr_gadt
| Sub_int : instr_gadt
| Mul_intint : instr_gadt
| Mul_intnat : instr_gadt
| Mul_natint : instr_gadt
| Mul_natnat : instr_gadt
| Ediv_intint : instr_gadt
| Ediv_intnat : instr_gadt
| Ediv_natint : instr_gadt
| Ediv_natnat : instr_gadt
| Lsl_nat : instr_gadt
| Lsr_nat : instr_gadt
| Or_nat : instr_gadt
| And_nat : instr_gadt
| And_int_nat : instr_gadt
| Xor_nat : instr_gadt
| Not_nat : instr_gadt
| Not_int : instr_gadt
| Seq : forall {aft bef trans : Set},
  'descr bef trans -> 'descr trans aft -> instr_gadt
| If : forall {aft bef : Set}, 'descr bef aft -> 'descr bef aft -> instr_gadt
| Loop : forall {rest : Set}, 'descr rest (bool * rest) -> instr_gadt
| Loop_left : forall {a b rest : Set},
  'descr (a * rest) (union a b * rest) -> instr_gadt
| Dip : forall {aft bef : Set}, 'descr bef aft -> instr_gadt
| Exec : instr_gadt
| Apply : forall {arg : Set}, 'ty arg -> instr_gadt
| Lambda : forall {arg ret : Set}, 'lambda arg ret -> instr_gadt
| Failwith : forall {a : Set}, 'ty a -> instr_gadt
| Nop : instr_gadt
| Compare : forall {a : Set}, comparable_ty a -> instr_gadt
| Eq : instr_gadt
| Neq : instr_gadt
| Lt : instr_gadt
| Gt : instr_gadt
| Le : instr_gadt
| Ge : instr_gadt
| Address : instr_gadt
| Contract : forall {p : Set}, 'ty p -> string -> instr_gadt
| Transfer_tokens : instr_gadt
| Create_account : instr_gadt
| Implicit_account : instr_gadt
| Create_contract : forall {g p : Set},
  'ty g -> 'ty p -> 'lambda (p * g) (list operation * g) -> option string ->
  instr_gadt
| Create_contract_2 : forall {g p : Set},
  'ty g -> 'ty p -> 'lambda (p * g) (list operation * g) -> option string ->
  instr_gadt
| Set_delegate : instr_gadt
| Now : instr_gadt
| Balance : instr_gadt
| Check_signature : instr_gadt
| Hash_key : instr_gadt
| Pack : forall {a : Set}, 'ty a -> instr_gadt
| Unpack : forall {a : Set}, 'ty a -> instr_gadt
| Blake2b : instr_gadt
| Sha256 : instr_gadt
| Sha512 : instr_gadt
| Steps_to_quota : instr_gadt
| Source : instr_gadt
| Sender : instr_gadt
| Self : forall {p : Set}, 'ty p -> string -> instr_gadt
| Amount : instr_gadt
| Dig : forall {aft bef rest x : Set},
  Z -> 'stack_prefix_preservation_witness (x * rest) rest bef aft -> instr_gadt
| Dug : forall {aft bef rest x : Set},
  Z -> 'stack_prefix_preservation_witness rest (x * rest) bef aft -> instr_gadt
| Dipn : forall {aft bef faft fbef : Set},
  Z -> 'stack_prefix_preservation_witness fbef faft bef aft ->
  'descr fbef faft -> instr_gadt
| Dropn : forall {C bef rest : Set},
  Z -> 'stack_prefix_preservation_witness rest rest bef C -> instr_gadt
| ChainId : instr_gadt

with stack_prefix_preservation_witness_gadt : Set :=
| Prefix :
  stack_prefix_preservation_witness_gadt ->
  stack_prefix_preservation_witness_gadt
| Rest : stack_prefix_preservation_witness_gadt

where "'end_of_stack" := (unit)
and "'ty" := (fun (_ : Set) => ty_gadt)
and "'stack_ty" := (fun (_ : Set) => stack_ty_gadt)
and "'typed_contract" := (fun (t_arg : Set) => 'ty t_arg * address)
and "'big_map" := (fun (t_key t_value : Set) =>
  big_map_skeleton (option Z.t) (map t_key (option t_value)) ('ty t_key)
    ('ty t_value))
and "'instr" := (fun (_ _ : Set) => instr_gadt)
and "'stack_prefix_preservation_witness" := (fun (_ _ _ _ : Set) =>
  stack_prefix_preservation_witness_gadt)
and "'descr" := (fun (t_bef t_aft : Set) =>
  descr_skeleton Alpha_context.Script.location ('stack_ty t_bef)
    ('stack_ty t_aft) ('instr t_bef t_aft))
and "'lambda" := (fun (t_arg t_ret : Set) =>
  lambda_skeleton
    ('descr (t_arg * 'end_of_stack) (t_ret * 'end_of_stack) *
      Alpha_context.Script.node))
and "'script" := (fun (t_arg t_storage : Set) =>
  script_skeleton
    ('lambda (pair t_arg t_storage) (pair (list operation) t_storage))
    ('ty t_arg) t_storage ('ty t_storage) (option string)).

Definition end_of_stack := 'end_of_stack.
Definition ty := 'ty.
Definition stack_ty := 'stack_ty.
Definition typed_contract := 'typed_contract.
Definition big_map := 'big_map.
Definition instr := 'instr.
Definition stack_prefix_preservation_witness :=
  'stack_prefix_preservation_witness.
Definition descr := 'descr.
Definition lambda := 'lambda.
Definition script := 'script.

Inductive ex_big_map : Set :=
| Ex_bm : forall {key value : Set}, big_map key value -> ex_big_map.
