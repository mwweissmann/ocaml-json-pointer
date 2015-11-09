let load_file f =
  let ic = open_in f in
  let n = in_channel_length ic in
  let s = Bytes.create n in
  let () = really_input ic s 0 n in
  let () = close_in ic in
  s

let _ =
  if Array.length Sys.argv != 3 then
    Printf.printf "Usage: %s path FILE\n" Sys.argv.(0)
  else
    let path = Json_pointer.of_string_exn Sys.argv.(1) in
    let data = Yojson.Safe.from_file Sys.argv.(2) in
    let result = Json_pointer.resolve_exn path data in
    Yojson.Safe.pretty_to_channel stdout result

