open Yojson.Safe

type t = string list

let path x = x

let concat = (@)

let of_path x = x

let empty = []

let replace input output =
  Str.global_replace (Str.regexp_string input) output

let of_string_exn path =
  let rec loop xs start pos =
    try
      match Bytes.get path pos with
      | '/' when pos = start -> loop xs start (pos + 1)
      | '/' -> loop ((Bytes.sub path start (pos - start))::xs) (pos + 1) (pos + 1)
      | c -> loop xs start (pos + 1)
    with
      | Invalid_argument _ ->
        if pos = start then xs
        else (Bytes.sub path start (pos - start))::xs
  in
  try
    if Bytes.get path 0 = '/' then
      let xs = List.rev (loop [] 1 1) in
      List.map (fun x -> let v = replace "~1" "/" x in replace "~0" "~" v) xs
    else
      raise (Failure "path not starting with '/'")
  with
    | Invalid_argument _ ->
      raise (Failure "empty path")

let of_string path =
  try
    Result.Ok (of_string_exn path)
  with
    | Failure x -> Result.Error (`EParser x)

let string path =
  let x = List.map (fun y -> let v = replace "~" "~0" y in replace "/" "~1" v) path in
  String.concat "/" ("" :: x)

let resolve_exn path doc =
  let rec crawl ps jd =
    match ps with
    | [] -> jd
    | x::xs ->
      begin match jd with
        | `Assoc js -> crawl xs (List.assoc x js)
        | _ -> raise Not_found
      end
  in
  crawl path doc

let resolve path doc =
  try
    Result.Ok (resolve_exn path doc)
  with
    | Not_found -> Result.Error `ENot_found

let iter_exn path f doc =
  let rec crawl ps jd =
    let () = f jd in
    match ps with
    | [] -> ()
    | x::xs ->
      begin match jd with
        | `Assoc js -> crawl xs (List.assoc x js)
        | _ -> raise Not_found
      end
  in
  crawl path doc

let iter path f doc =
  try
    Result.Ok (iter_exn path f doc)
  with
    | Not_found -> Result.Error `ENot_found

