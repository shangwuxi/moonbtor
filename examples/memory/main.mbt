///|
fn main raise {
  let model = @moonbtor.parse(
    "1 sort bitvec 1\n2 sort bitvec 2\n3 sort array 2 2\n4 zero 2\n5 state 3 mem\n6 init 3 5 4\n7 input 2 addr\n8 input 2 data\n9 write 3 5 7 8\n10 next 3 5 9\n11 read 2 5 7\n12 neq 1 11 4\n13 bad 12",
  ).unwrap()
  let q = model.query(1).unwrap()
  let action = @env.get_env_var("MOONBTOR_ACTION").unwrap_or("")
  if action == "export" {
    println(q.formula().to_dimacs())
    return
  }
  if action == "decode" {
    let assignment = q
      .formula()
      .parse_assignment(@env.get_env_var("MOONBTOR_ASSIGNMENT").unwrap())
      .unwrap()
    let trace = q.decode_typed(assignment).unwrap()
    ignore(model.replay_typed(trace).unwrap())
    println("external array assignment decoded and independently replayed")
    return
  }
  match model.check_typed(2).unwrap() {
    Counterexample(trace) => {
      assert_eq(trace.frames.length(), 2)
      ignore(model.replay_typed(trace).unwrap())
      println(
        "array counterexample: 1 transition, exact 4-cell memory, replay passed",
      )
    }
    _ => panic()
  }
}
