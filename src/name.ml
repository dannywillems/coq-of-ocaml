(** Local identifiers, used for variable names in patterns for example. *)
open SmartPrint

(** Just a [string]. *)
type t = Make of string

module Set = Set.Make (struct
  type nonrec t = t
  let compare = compare
end)

module Map = Map.Make (struct
  type nonrec t = t
  let compare = compare
end)

let equal (name1 : t) (name2 : t) : bool =
  match (name1, name2) with
  | (Make name1, Make name2) -> String.equal name1 name2

let escape_operator_character (c : char) : string =
  match c with
  | '=' -> "eq"
  | '<' -> "lt"
  | '>' -> "gt"
  | '@' -> "at"
  | '^' -> "caret"
  | '|' -> "pipe"
  | '&' -> "and"
  | '+' -> "plus"
  | '-' -> "minus"
  | '*' -> "star"
  | '/' -> "div"
  | '$' -> "dollar"
  | '%' -> "percent"
  | '?' -> "question"
  | '!' -> "exclamation"
  | '~' -> "tilde"
  | '.' -> "point"
  | ':' -> "colon"
  | _ -> String.make 1 c

let escape_operator (s : string) : string =
  let b = Buffer.create 0 in
  s |> String.iter (fun c ->
    Buffer.add_string b (escape_operator_character c)
  );
  Buffer.contents b

let escape_reserved_word (is_value : bool) (s : string) : string =
  let escape_if_value s =
    if is_value then "__" ^ s ^ "_value" else s in
  match s with
  | "bool" -> escape_if_value s
  | "bytes" -> escape_if_value s
  | "error" -> "__error"
  | "exists" -> "__exists"
  | "exists2" -> "__exists2"
  | "float" -> escape_if_value s
  | "int" -> escape_if_value s
  | "int32" -> escape_if_value s
  | "int64" -> escape_if_value s
  | "left" -> "__left"
  | "list" -> escape_if_value s
  | "mod" -> "__mod"
  | "nativeint" -> escape_if_value s
  | "option" -> escape_if_value s
  | "pack" -> "__pack"
  | "ref" -> escape_if_value s
  | "result" -> escape_if_value s
  | "return" -> "__return"
  | "right" -> "__right"
  | "Set" -> "__Set"
  | "string" -> escape_if_value s
  | "unit" -> escape_if_value s
  | "Variable" -> "__Variable"
  | _ -> s

let substitute_first_dollar (s : string) : string =
  if String.length s <> 0 && String.get s 0 = '$' then
    "__" ^ String.sub s 1 (String.length s - 1)
  else
    s

let convert (is_value : bool) (s : string) : string =
  let s = substitute_first_dollar s in
  let s_escaped_operator = escape_operator s in
  if s_escaped_operator <> s then
    "op_" ^ s_escaped_operator
  else
    escape_reserved_word is_value s

(** Lift a [string] to an identifier. *)
let of_string (is_value : bool) (s : string) : t =
  Make (convert is_value s)

(** Import an OCaml identifier. *)
let of_ident (is_value : bool) (i : Ident.t) : t =
  of_string is_value (Ident.name i)

let to_string (name : t) : string =
  let Make name = name in
  name

let prefix_by_single_quote (name : t) : t =
  let Make name = name in
  Make ("'" ^ name)

let prefix_by_t (name : t) : t =
  let Make name = name in
  Make ("t_" ^ name)

let prefix_by_with (name : t) : t =
  let Make name = name in
  Make ("with_" ^ name)

let suffix_by_skeleton (name : t) : t =
  let Make name = name in
  Make (name ^ "_skeleton")

(** Pretty-print a name to Coq. *)
let to_coq (name : t) : SmartPrint.t =
  !^ (to_string name)