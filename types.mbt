///|
/// A located, non-secret diagnostic. Line zero denotes an API error.
#derive(Debug, Eq)
pub(all) struct Diagnostic {
  line : Int32
  message : String
}

///|
#derive(Debug)
suberror Failure {
  Problem(Diagnostic)
}

///|
fn fail(line : Int32, message : String) -> Unit raise Failure {
  raise Problem({ line, message, })
}

///|
/// A typed instruction. Operands are indices in the validated node array.
priv struct Node {
  id : Int32
  op : String
  width : Int32
  sort : ValueSort
  args : Array[Int32]
  params : Array[Int32]
  value_bits : Array[Bool]
  symbol : String
  input_dependent : Bool
}

///|
/// An immutable validated model. No mutable internal arrays are returned.
pub struct Model {
  priv nodes : Array[Node]
  priv states : Array[Int32]
  priv inputs : Array[Int32]
  priv initial : Array[(Int32, Int32)]
  priv updates : Array[(Int32, Int32)]
  priv bad : Array[Int32]
  priv constraints : Array[Int32]
  priv outputs : Array[Int32]
  priv fair : Array[Int32]
  priv justice : Array[Array[Int32]]
}

///|
/// Parser limits, independent of the exact finite-domain execution budget.
#derive(Debug, Eq)
pub(all) struct ParseLimits {
  max_lines : Int32
  max_line_length : Int32
  max_nodes : Int32
  max_width : Int32
}

///|
pub fn ParseLimits::default() -> ParseLimits {
  {
    max_lines: 20000,
    max_line_length: 16384,
    max_nodes: 10000,
    max_width: 4096,
  }
}

///|
/// Stable declaration metadata for assigning inputs and interpreting traces.
#derive(Debug, Eq)
pub(all) struct Port {
  id : Int32
  width : Int32
  symbol : String
}

///|
pub fn Model::state_ports(self : Model) -> Array[Port] {
  self.states.map(i => {
    id: self.nodes[i].id,
    width: self.nodes[i].width,
    symbol: self.nodes[i].symbol,
  })
}

///|
pub fn Model::input_ports(self : Model) -> Array[Port] {
  self.inputs.map(i => {
    id: self.nodes[i].id,
    width: self.nodes[i].width,
    symbol: self.nodes[i].symbol,
  })
}

///|
pub fn Model::node_count(self : Model) -> Int32 {
  self.nodes.length()
}

///|
pub fn Model::bad_count(self : Model) -> Int32 {
  self.bad.length()
}

///|
fn mask(width : Int32) -> UInt64 {
  if width >= 64 {
    0UL.lnot()
  } else {
    (1UL << width) - 1UL
  }
}

///|
/// Arrays use increasing unsigned address order, each cell little endian.
#derive(Debug, Eq)
pub(all) struct TypedFrame {
  state : Array[Array[Bool]]
  inputs : Array[Array[Bool]]
}

///|
#derive(Debug, Eq)
pub(all) struct TypedPort {
  id : Int32
  width : Int32
  index_width : Int32
  symbol : String
}

///|
pub fn Model::typed_state_ports(self : Model) -> Array[TypedPort] {
  self.states.map(i => {
    id: self.nodes[i].id,
    width: self.nodes[i].width,
    index_width: self.nodes[i].index_width(),
    symbol: self.nodes[i].symbol,
  })
}

///|
pub fn Model::typed_input_ports(self : Model) -> Array[TypedPort] {
  self.inputs.map(i => {
    id: self.nodes[i].id,
    width: self.nodes[i].width,
    index_width: self.nodes[i].index_width(),
    symbol: self.nodes[i].symbol,
  })
}

///|
fn Node::size(self : Node) -> Int32 raise Failure {
  if self.sort.flat_bits > 1000000 {
    fail(0, "exact array expansion exceeds the 1000000-bit resource budget")
  }
  self.sort.flat_bits
}

///|
/// A structural BTOR2 sort, with arrays in unsigned flattened index order.
pub struct ValueSort {
  priv key : Int32
  priv leaf_width : Int32
  priv flat_bits : Int32
  priv parts : (ValueSort, ValueSort)?
}

///|
pub fn ValueSort::bit_width(self : ValueSort) -> Int32? {
  if self.parts is None {
    Some(self.leaf_width)
  } else {
    None
  }
}

///|
pub fn ValueSort::array_parts(self : ValueSort) -> (ValueSort, ValueSort)? {
  self.parts
}

///|
/// None means exact expansion exceeds the implementation's bit budget.
pub fn ValueSort::flattened_width(self : ValueSort) -> Int32? {
  if self.flat_bits > 1000000 {
    None
  } else {
    Some(self.flat_bits)
  }
}

///|
pub fn Model::state_sort(self : Model, ordinal : Int32) -> ValueSort? {
  if ordinal < 0 || ordinal >= self.states.length() {
    None
  } else {
    Some(self.nodes[self.states[ordinal]].sort)
  }
}

///|
pub fn Model::input_sort(self : Model, ordinal : Int32) -> ValueSort? {
  if ordinal < 0 || ordinal >= self.inputs.length() {
    None
  } else {
    Some(self.nodes[self.inputs[ordinal]].sort)
  }
}

///|
fn Node::index_width(self : Node) -> Int32 {
  match self.sort.parts {
    None => 0
    Some((index, _)) => index.flat_bits
  }
}

///|
fn Model::check_work_budget(self : Model, frames : Int32) -> Unit raise Failure {
  let mut work = 0L
  for n in self.nodes {
    let size = n.size().to_int64()
    let cost = match n.op {
      "mul" | "umulo" | "smulo" | "udiv" | "urem" | "sdiv" | "srem" | "smod" =>
        size * size * 4L
      _ => size
    }
    work += cost
    if work > 20000000L / frames.to_int64() {
      fail(0, "arithmetic work budget exhausted")
    }
  }
}
