# ocaml-json-pointer
This OCaml library implements [RFC 6901 -- JSON pointer](https://tools.ietf.org/html/rfc6901).

JSON Pointer defines a string syntax for identifying a specific value
within a JavaScript Object Notation (JSON) document.

Given the following JSON data
```Javascript
{
  a: {
    b: "hello world"
  }
}
```

you can extract a JSON sub-document and print ```hello world``` as follows:

```ocaml
let _ =
  let path = Json_pointer.of_string_exn "/a/b" in
  let data = Yojson.Safe.from_file the_json_file in
  let result = Json_pointer.resolve_exn path data in
  Yojson.Safe.pretty_to_channel stdout result
```

The json-pointer library is written by [Markus Weissmann](http://www.mweissmann.de).

The source-code of ocaml-json-pointer is available under the MIT license.
