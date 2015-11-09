type t

val of_string : string -> (t, [> `EParser of string]) Result.result

val of_string_exn : string -> t

val string : t -> string

val path : t -> string list

val of_path : string list -> t

val empty : t

val concat : t -> t -> t

val resolve : t -> Yojson.Safe.json -> (Yojson.Safe.json, [> `ENot_found]) Result.result

val resolve_exn : t -> Yojson.Safe.json -> Yojson.Safe.json

val iter : t -> (Yojson.Safe.json -> unit) -> Yojson.Safe.json -> (unit, [> `ENot_found]) Result.result

val iter_exn : t -> (Yojson.Safe.json -> unit) -> Yojson.Safe.json -> unit

