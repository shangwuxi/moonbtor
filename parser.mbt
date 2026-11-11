///|
/// Parse the supported safety fragment. Unsupported tags fail explicitly.
pub fn parse(
  text : String,
  limits~ : ParseLimits = ParseLimits::default(),
) -> Result[Model, Diagnostic] {
  Ok(parse_inner(text, limits)) catch {
    Problem(d) => Err(d)
  }
}

///|
fn parse_inner(text : String, limits : ParseLimits) -> Model raise Failure {
  if limits.max_lines <= 0 ||
    limits.max_line_length <= 0 ||
    limits.max_nodes <= 0 ||
    limits.max_width < 1 ||
    limits.max_width > 32 {
    fail(0, "invalid parser limits")
  }
  let nodes : Array[Node] = []
  let states : Array[Int32] = []
  let inputs : Array[Int32] = []
  let initial : Array[(Int32, Int32)] = []
  let updates : Array[(Int32, Int32)] = []
  let bad : Array[Int32] = []
  let constraints : Array[Int32] = []
  let outputs : Array[Int32] = []
  let sorts : Map[Int32, Int32] = {}
  let ids : Map[Int32, Int32] = {}
  let mut previous = 0
  let mut line = 0
  for raw in text.split("\n") {
    line += 1
    if line > limits.max_lines {
      fail(line, "line budget exceeded")
    }
    let raw = raw.to_string()
    if raw.length() > limits.max_line_length {
      fail(line, "line length exceeded")
    }
    let w = tokens(raw)
    if w.is_empty() {
      continue
    }
    if w.length() < 2 {
      fail(line, "missing instruction tag")
    }
    let id = natural(w[0], line)
    if id <= previous {
      fail(line, "node IDs must be positive and strictly increasing")
    }
    previous = id
    if line > limits.max_nodes + limits.max_lines {
      fail(line, "instruction budget exceeded")
    }
    let op = w[1]
    if op == "sort" {
      if w.length() != 4 || w[2] != "bitvec" {
        fail(line, "only bitvec sorts are supported")
      }
      let width = natural(w[3], line)
      if width < 1 || width > limits.max_width {
        fail(line, "bit-vector width outside supported bound")
      }
      sorts[id] = width
      continue
    }
    if op == "bad" || op == "constraint" || op == "output" {
      need(w, 3, line)
      let arg = lookup(ids, natural(w[2], line), line)
      if op != "output" && nodes[arg].width != 1 {
        fail(line, "property must have width one")
      }
      if op == "bad" {
        bad.push(arg)
      } else if op == "constraint" {
        constraints.push(arg)
      } else {
        outputs.push(arg)
      }
      continue
    }
    if w.length() < 3 {
      fail(line, "missing sort")
    }
    let sid = natural(w[2], line)
    let width = match sorts.get(sid) {
      Some(v) => v
      None => {
        fail(line, "unknown sort")
        0
      }
    }
    if op == "init" || op == "next" {
      need(w, 5, line)
      let target = lookup(ids, natural(w[3], line), line)
      let source = lookup(ids, natural(w[4], line), line)
      if nodes[target].op != "state" ||
        nodes[target].width != width ||
        nodes[source].width != width {
        fail(line, "init/next require a state and equally sized expression")
      }
      let list = if op == "init" { initial } else { updates }
      for pair in list {
        if pair.0 == target {
          fail(line, "duplicate init/next assignment")
        }
      }
      list.push((target, source))
      continue
    }
    let args : Array[Int32] = []
    let params : Array[Int32] = []
    let mut value = 0UL
    let mut count = 3
    if op == "input" ||
      op == "state" ||
      op == "zero" ||
      op == "one" ||
      op == "ones" {
      if op == "one" {
        value = 1UL
      }
      if op == "ones" {
        value = mask(width)
      }
    } else if op == "const" || op == "consth" || op == "constd" {
      count = 4
      if w.length() < 4 {
        fail(line, "missing constant")
      }
      let base = if op == "const" {
        2
      } else if op == "consth" {
        16
      } else {
        10
      }
      value = constant(w[3], base, width, line)
      if op == "const" && w[3].length() != width {
        fail(line, "binary constant must specify exactly width bits")
      }
    } else {
      let arity = match op {
        "not"
        | "neg"
        | "inc"
        | "dec"
        | "redand"
        | "redor"
        | "redxor"
        | "slice"
        | "uext"
        | "sext" => 1
        "and"
        | "or"
        | "xor"
        | "nand"
        | "nor"
        | "xnor"
        | "add"
        | "sub"
        | "mul"
        | "eq"
        | "neq"
        | "ult"
        | "ulte"
        | "ugt"
        | "ugte"
        | "slt"
        | "slte"
        | "sgt"
        | "sgte"
        | "sll"
        | "srl"
        | "sra"
        | "concat"
        | "iff"
        | "implies" => 2
        "ite" => 3
        _ => {
          fail(line, "unsupported instruction: " + op)
          0
        }
      }
      let extra = if op == "slice" {
        2
      } else if op == "uext" || op == "sext" {
        1
      } else {
        0
      }
      count = 3 + arity + extra
      if w.length() < count {
        fail(line, "missing operands")
      }
      for j = 0; j < arity; j = j + 1 {
        args.push(lookup(ids, natural(w[3 + j], line), line))
      }
      for j = 0; j < extra; j = j + 1 {
        params.push(natural(w[3 + arity + j], line))
      }
      validate_op(op, width, args, params, nodes, line)
    }
    need(w, count, line)
    if nodes.length() >= limits.max_nodes {
      fail(line, "node budget exceeded")
    }
    let symbol = if w.length() > count { w[count] } else { "" }
    let index = nodes.length()
    ids[id] = index
    nodes.push({ id, op, width, args, params, value, symbol, })
    if op == "state" {
      states.push(index)
    }
    if op == "input" {
      inputs.push(index)
    }
  }
  if nodes.is_empty() {
    fail(0, "model has no value nodes")
  }
  { nodes, states, inputs, initial, updates, bad, constraints, outputs, }
}

///|
fn validate_op(
  op : String,
  width : Int32,
  args : Array[Int32],
  params : Array[Int32],
  nodes : Array[Node],
  line : Int32,
) -> Unit raise Failure {
  let a = nodes[args[0]].width
  if op == "slice" {
    if params[0] < params[1] ||
      params[0] >= a ||
      width != params[0] - params[1] + 1 {
      fail(line, "invalid slice bounds or width")
    }
  } else if op == "uext" || op == "sext" {
    if params[0] > 32 || width != a + params[0] {
      fail(line, "invalid extension width")
    }
  } else if op == "redand" || op == "redor" || op == "redxor" {
    if width != 1 {
      fail(line, "reduction result must have width one")
    }
  } else if op == "ite" {
    if a != 1 || nodes[args[1]].width != width || nodes[args[2]].width != width {
      fail(line, "ite condition/branch sort mismatch")
    }
  } else if op == "concat" {
    if width != a + nodes[args[1]].width {
      fail(line, "concat width mismatch")
    }
  } else {
    for arg in args {
      if nodes[arg].width != a {
        fail(line, "operand sort mismatch")
      }
    }
    let comparison = op == "eq" ||
      op == "neq" ||
      op == "ult" ||
      op == "ulte" ||
      op == "ugt" ||
      op == "ugte" ||
      op == "slt" ||
      op == "slte" ||
      op == "sgt" ||
      op == "sgte"
    if comparison {
      if width != 1 {
        fail(line, "comparison result must have width one")
      }
    } else if width != a {
      fail(line, "result sort mismatch")
    }
    if (op == "iff" || op == "implies") && a != 1 {
      fail(line, "Boolean operator requires width one")
    }
  }
}
