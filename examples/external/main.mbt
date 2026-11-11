///|
/// Integration workflow: strict external SAT output -> decoded inputs -> concrete replay.
fn main {
  try {
    let m = @moonbtor.parse(
      "1 sort bitvec 2\n2 sort bitvec 1\n3 input 1 selection\n4 constd 1 2\n5 eq 2 3 4\n6 bad 5",
    ).unwrap()
    let q = m.query(0).unwrap()
    let output = @env.get_env_var("MOONBTOR_ASSIGNMENT").unwrap_or(
      "s SATISFIABLE\nv 1 -2 3 4 0",
    )
    let assignment = q.formula().parse_assignment(output).unwrap()
    let trace = q.decode(assignment).unwrap()
    assert_eq(trace.frames[0].inputs, [2UL])
    assert_true(m.replay(trace) is Ok(_))
    println("external: DIMACS assignment decoded selection=2; replay passed")
  } catch {
    _ => abort("external solver workflow failed")
  }
}
