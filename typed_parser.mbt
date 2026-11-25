///|
fn abs_id(id : Int32) -> Int32 {
  if id < 0 {
    -id
  } else {
    id
  }
}

///|
fn constant_source(nodes : Array[Node], i : Int32) -> Bool {
  let n = nodes[i]
  if n.id < 0 {
    return constant_source(nodes, n.args[0])
  }
  n.op == "zero" ||
  n.op == "one" ||
  n.op == "ones" ||
  n.op == "const" ||
  n.op == "consth" ||
  n.op == "constd"
}

///|
fn sort_ref(
  sorts : Map[Int32, ValueSort],
  text : String,
  line : Int32,
) -> ValueSort raise Failure {
  match sorts.get(natural(text, line)) {
    Some(s) => s
    None => raise Problem({ line, message: "unknown sort", })
  }
}

///|
/// Complement references are represented by shared synthetic NOT nodes.
fn reference(
  text : String,
  ids : Map[Int32, Int32],
  nodes : Array[Node],
  line : Int32,
) -> Int32 raise Failure {
  if text.length() == 0 || text[0] != '-' {
    return lookup(ids, natural(text, line), line)
  }
  let id = natural(text[1:].to_owned(), line)
  let source = lookup(ids, id, line)
  if nodes[source].sort.parts is Some(_) {
    fail(line, "array references cannot be complemented")
  }
  match ids.get(-id) {
    Some(i) => i
    None => {
      let n = nodes[source]
      let i = nodes.length()
      nodes.push({
        id: -id,
        op: "not",
        width: n.width,
        sort: n.sort,
        args: [source],
        params: [],
        value_bits: [],
        symbol: "",
        input_dependent: n.input_dependent,
      })
      ids[-id] = i
      i
    }
  }
}

///|
fn parse_bits(
  text : String,
  base : Int32,
  width : Int32,
  line : Int32,
) -> Array[Bool] raise Failure {
  let negative = text.length() > 0 && text[0] == '-'
  if negative && base != 10 {
    fail(line, "only decimal constants may be negative")
  }
  let start = if negative { 1 } else { 0 }
  if text.length() == start {
    fail(line, "empty constant")
  }
  let out = Array::make(width, false)
  for j = start; j < text.length(); j = j + 1 {
    let c = text[j].to_int()
    let d = if c >= 48 && c <= 57 {
      c - 48
    } else if c >= 65 && c <= 70 {
      c - 55
    } else if c >= 97 && c <= 102 {
      c - 87
    } else {
      -1
    }
    if d < 0 || d >= base {
      fail(line, "invalid constant digit")
    }
    let mut carry = d
    for i = 0; i < width; i = i + 1 {
      carry += if out[i] { base } else { 0 }
      out[i] = carry % 2 == 1
      carry /= 2
    }
    if carry != 0 {
      fail(line, "constant does not fit declared width")
    }
  }
  if negative {
    if out[width - 1] && out.iter().take(width - 1).any(x => x) {
      fail(line, "negative constant does not fit signed width")
    }
    return concrete_neg(out)
  }
  out
}

///|
fn validate_typed_op(
  op : String,
  sort : ValueSort,
  args : Array[Int32],
  params : Array[Int32],
  nodes : Array[Node],
  line : Int32,
) -> Unit raise Failure {
  let a = nodes[args[0]]
  if op == "read" || op == "write" {
    match a.sort.parts {
      Some((index, element)) =>
        if nodes[args[1]].sort.key != index.key ||
          (if op == "read" {
            sort.key != element.key
          } else {
            sort.key != a.sort.key || nodes[args[2]].sort.key != element.key
          }) {
          fail(line, op + " sort mismatch")
        }
      None => fail(line, op + " requires an array")
    }
  } else if op == "ite" {
    if a.sort.bit_width() != Some(1) ||
      nodes[args[1]].sort.key != sort.key ||
      nodes[args[2]].sort.key != sort.key {
      fail(line, "ite sort mismatch")
    }
  } else if op == "eq" || op == "neq" {
    if sort.bit_width() != Some(1) || a.sort.key != nodes[args[1]].sort.key {
      fail(line, "equality sort mismatch")
    }
  } else {
    if sort.parts is Some(_) || args.any(i => nodes[i].sort.parts is Some(_)) {
      fail(line, "operator requires bit-vector operands")
    }
    validate_op(op, sort.leaf_width, args, params, nodes, line)
  }
}
