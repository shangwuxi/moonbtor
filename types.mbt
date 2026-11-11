///|
/// A located, non-secret diagnostic. Line zero denotes an API error.
pub(all) struct Diagnostic {
  line : Int32
  message : String
} derive(Debug, Eq)

///|
suberror Failure {
  Problem(Diagnostic)
} derive(Debug)

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
  args : Array[Int32]
  params : Array[Int32]
  value : UInt64
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
}

///|
/// Parser and allocation limits. Widths are deliberately bounded to 32 bits.
pub(all) struct ParseLimits {
  max_lines : Int32
  max_line_length : Int32
  max_nodes : Int32
  max_width : Int32
} derive(Debug, Eq)

///|
pub fn ParseLimits::default() -> ParseLimits {
  { max_lines: 20000, max_line_length: 4096, max_nodes: 10000, max_width: 32, }
}

///|
/// Stable declaration metadata for assigning inputs and interpreting traces.
pub(all) struct Port {
  id : Int32
  width : Int32
  symbol : String
} derive(Debug, Eq)

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
  (1UL << width) - 1UL
}
