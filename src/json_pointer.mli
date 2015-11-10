type t
(** type of a JSON pointer *)

val of_string : string -> (t, [> `EParser of string]) Result.result
(** create a JSON pointer from a string of the form [/a/b/c]. If an error
    occurs during parsing, [`EParser] is returned with a description of the
    server. *)

val of_string_exn : string -> t
(** create a JSON pointer from a string; this functions behaves identical
    to [of_string] but raises a [Failure] exception on parsing errors. *)

val string : t -> string
(** return the string of the JSON pointer. For a well-formed JSON-pointer,
  [string (of_string x) = x]. *)

val path : t -> string list
(** return a list of strings representing the selectors. [path (of_string "/a/b") = ["a"; "b"]] *)

val of_path : string list -> t
(** create a JSON pointer from a list of selector strings. [string (of_path ["a"; "b"]) = "/a/b"] *)

val empty : t
(** The empty pointer. [path empty = []] *)

val concat : t -> t -> t
(** Concatenate two pointers. [(path a) @ (path b) = path (concat a b)] *)

val resolve : t -> Yojson.Safe.json -> (Yojson.Safe.json, [> `ENot_found]) Result.result
(** Resolve the JSON pointer on a given JSON document, returning the selected sub-document. *)

val resolve_exn : t -> Yojson.Safe.json -> Yojson.Safe.json
(** Resolve the JSON pointer on a given JSON document. This function is identical to [resolve]
    but raises [Not_found] exception if the pointer is not valid for the given document. *)

val iter : t -> (Yojson.Safe.json -> unit) -> Yojson.Safe.json -> (unit, [> `ENot_found]) Result.result
(** Iterate along the path of the pointer. The function [f] in [iter pt f doc] will first
    be called with the whole document [doc] and then the sequent sub-documents until it
    is called last with the target of the pointer. *)

val iter_exn : t -> (Yojson.Safe.json -> unit) -> Yojson.Safe.json -> unit
(** [iter_exn] behaves identical to [iter] but raises [Not_found] os the pointer is not
    valid for the given document. *)

