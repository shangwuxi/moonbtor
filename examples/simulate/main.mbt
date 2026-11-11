///|
/// Teaching workflow: input-controlled accumulator, explicit time frames and replay.
fn main {
  try {
    let m = @moonbtor.parse(
      "1 sort bitvec 3\n2 sort bitvec 1\n3 input 1 amount\n4 zero 1\n5 state 1 total\n6 init 1 5 4\n7 add 1 5 3\n8 next 1 5 7\n9 constd 1 5\n10 eq 2 5 9\n11 bad 10\n12 output 5",
    ).unwrap()
    let first : @moonbtor.Frame = { state: [0UL], inputs: [2UL], }
    let second = m.step(first, [3UL], []).unwrap()
    let third = m.step(second, [0UL], []).unwrap()
    let trace : @moonbtor.Trace = {
      frames: [first, second, third],
      bad_index: 0,
    }
    assert_eq(third.state, [5UL])
    assert_eq(m.observe(third).unwrap().outputs, [5UL])
    let restored = @moonbtor.parse_trace(trace.to_json_string()).unwrap()
    assert_true(m.replay(restored) is Ok(_))
    assert_true(m.replay({ frames: [first, third], bad_index: 0, }) is Err(_))
    println("simulate: [0,2,5]; JSON replay passed; skipped frame rejected")
  } catch {
    _ => abort("simulation workflow failed")
  }
}
