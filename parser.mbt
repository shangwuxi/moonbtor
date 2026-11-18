///|
/// Parse standard BTOR2 bit-vector/array transition systems and properties.
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
    limits.max_lines > 200000 ||
    limits.max_line_length <= 0 ||
    limits.max_line_length > 65536 ||
    limits.max_nodes <= 0 ||
    limits.max_nodes > 100000 ||
    limits.max_width < 1 ||
    limits.max_width > 4096 {
    fail(0, "invalid parser limits")
  }
  if text.length() > 8000000 {
    fail(0, "model text budget exceeded")
  }
  let nodes : Array[Node] = []
  let states : Array[Int32] = []
  let inputs : Array[Int32] = []
  let initial : Array[(Int32, Int32)] = []
  let updates : Array[(Int32, Int32)] = []
  let bad : Array[Int32] = []
  let constraints : Array[Int32] = []
  let outputs : Array[Int32] = []
  let fair : Array[Int32] = []
  let justice : Array[Array[Int32]] = []
  let sorts : Map[Int32, (Int32, Int32)] = Map([])
  let ids : Map[Int32, Int32] = Map([])
  let mut previous = 0
  let mut line = 0
  for raw in text.split("\n") {
    line += 1
    if line > limits.max_lines {
      fail(line, "line budget exceeded")
    }
    let raw = raw.to_owned()
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
    let op = w[1]
    if op == "sort" {
      if w.length() == 4 && w[2] == "bitvec" {
        let width = natural(w[3], line)
        if width < 1 || width > limits.max_width {
          fail(line, "bit-vector width outside parser resource limit")
        }
        sorts[id] = (width, 0)
      } else if w.length() == 5 && w[2] == "array" {
        let a = sort_ref(sorts, w[3], line)
        let b = sort_ref(sorts, w[4], line)
        if a.1 != 0 || b.1 != 0 {
          fail(line, "array sorts require bit-vector index and element")
        }
        sorts[id] = (b.0, a.0)
      } else {
        fail(line, "invalid BTOR2 sort declaration")
      }
      continue
    }
    if op == "justice" {
      if w.length() < 3 {
        fail(line, "missing justice size")
      }
      let count = natural(w[2], line)
      if count < 1 || count > limits.max_nodes {
        fail(line, "invalid justice size")
      }
      need(w, count + 3, line)
      let group = []
      for j = 0; j < count; j = j + 1 {
        let arg = reference(w[3 + j], ids, nodes, line)
        if nodes[arg].width != 1 || nodes[arg].index_width != 0 {
          fail(line, "justice requires Boolean operands")
        }
        group.push(arg)
      }
      justice.push(group)
      continue
    }
    if op == "bad" || op == "constraint" || op == "output" || op == "fair" {
      need(w, 3, line)
      let arg = reference(w[2], ids, nodes, line)
      if nodes[arg].index_width != 0 ||
        (op != "output" && nodes[arg].width != 1) {
        fail(line, "property must have width one")
      }
      if op == "bad" {
        bad.push(arg)
      } else if op == "constraint" {
        constraints.push(arg)
      } else if op == "fair" {
        fair.push(arg)
      } else {
        outputs.push(arg)
      }
      continue
    }
    if w.length() < 3 {
      fail(line, "missing sort")
    }
    let (width, index_width) = sort_ref(sorts, w[2], line)
    if op == "init" || op == "next" {
      need(w, 5, line)
      let target = lookup(ids, natural(w[3], line), line)
      let source = reference(w[4], ids, nodes, line)
      if nodes[target].op != "state" ||
        nodes[target].width != width ||
        nodes[target].index_width != index_width ||
        nodes[source].width != width ||
        (
          nodes[source].index_width != index_width &&
          !(op == "init" && index_width > 0 && nodes[source].index_width == 0)
        ) {
        fail(line, "init/next require a state and equally sized expression")
      }
      if op == "init" &&
        (
          abs_id(nodes[source].id) >= nodes[target].id ||
          nodes[source].input_dependent
        ) {
        fail(line, "init source must precede state and cannot depend on input")
      }
      if op == "init" &&
        index_width > 0 &&
        nodes[source].index_width == 0 &&
        !constant_source(nodes, source) {
        fail(line, "array scalar initialization requires a constant")
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
    let mut value_bits : Array[Bool] = []
    let mut count = 3
    if op == "input" ||
      op == "state" ||
      op == "zero" ||
      op == "one" ||
      op == "ones" {
      if op != "input" && op != "state" {
        if index_width != 0 {
          fail(line, "constant must have bit-vector sort")
        }
        value_bits = Array::makei(width, i => {
          op == "ones" || (op == "one" && i == 0)
        })
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
      if index_width != 0 {
        fail(line, "constant must have bit-vector sort")
      }
      value_bits = parse_bits(w[3], base, width, line)
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
        "udiv"
        | "urem"
        | "sdiv"
        | "srem"
        | "smod"
        | "rol"
        | "ror"
        | "uaddo"
        | "saddo"
        | "usubo"
        | "ssubo"
        | "umulo"
        | "smulo"
        | "sdivo"
        | "read" => 2
        "ite" | "write" => 3
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
        args.push(reference(w[3 + j], ids, nodes, line))
      }
      for j = 0; j < extra; j = j + 1 {
        params.push(natural(w[3 + arity + j], line))
      }
      validate_typed_op(op, width, index_width, args, params, nodes, line)
    }
    need(w, count, line)
    if nodes.length() >= limits.max_nodes {
      fail(line, "node budget exceeded")
    }
    let symbol = if w.length() > count { w[count] } else { "" }
    let index = nodes.length()
    ids[id] = index
    let input_dependent = op == "input" ||
      args.any(i => nodes[i].input_dependent)
    nodes.push({
      id,
      op,
      width,
      index_width,
      args,
      params,
      value_bits,
      symbol,
      input_dependent,
    })
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
  if nodes.length() > limits.max_nodes {
    fail(line, "node budget exceeded")
  }
  {
    nodes,
    states,
    inputs,
    initial,
    updates,
    bad,
    constraints,
    outputs,
    fair,
    justice,
  }
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
    if params[0] > 4096 || width != a + params[0] {
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
      op == "sgte" ||
      op == "uaddo" ||
      op == "saddo" ||
      op == "usubo" ||
      op == "ssubo" ||
      op == "umulo" ||
      op == "smulo" ||
      op == "sdivo"
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
