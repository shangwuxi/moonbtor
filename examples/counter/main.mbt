///|
/// Hardware workflow: find the first overflow of a two-bit synchronous counter.
fn main {
  try {
    let model = @moonbtor.parse(
      "1 sort bitvec 2\n2 sort bitvec 1\n3 zero 1\n4 state 1 count\n5 init 1 4 3\n6 inc 1 4\n7 next 1 4 6\n8 constd 1 3\n9 eq 2 4 8\n10 bad 9 overflow",
    ).unwrap()
    assert_eq(model.check(2).unwrap(), @moonbtor.BoundedSafe(2))
    match model.check(5).unwrap() {
      Counterexample(trace) => {
        assert_eq(trace.frames.map(f => f.state[0]), [0UL, 1UL, 2UL, 3UL])
        assert_true(model.replay(trace) is Ok(_))
        println(trace.to_json_string())
        println("counter: shortest bad frame = 3; independent replay passed")
      }
      _ => abort("counterexample expected")
    }
  } catch {
    _ => abort("counter workflow failed")
  }
}
