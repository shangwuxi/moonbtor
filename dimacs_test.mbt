///|
test "DIMACS roundtrip spans lines and handles empty clauses" {
  let f = @moonbtor.parse_dimacs("c authored\np cnf 2 2\n1\n-2 0\n2 0").unwrap()
  let g = @moonbtor.parse_dimacs(f.to_dimacs()).unwrap()
  assert_eq(g.variable_count(), 2)
  assert_eq(g.clause(0), Some([1, -2]))
  assert_true(g.solve() is Satisfiable(_))
  assert_true(
    @moonbtor.parse_dimacs("p cnf 0 1\n0").unwrap().solve() is Unsatisfiable,
  )
  for
    bad in [
      "1 0", "p cnf 1 1\n2 0", "p cnf 1 1\n1", "p cnf 1 0\n0", "p cnf 0 0\np cnf 0 0",
      "p cnf 1 1\n-0",
    ] {
    assert_true(@moonbtor.parse_dimacs(bad) is Err(_))
  }
}

///|
test "external assignments are complete unique terminated and satisfying" {
  let f = @moonbtor.parse_dimacs("p cnf 2 1\n1 2 0").unwrap()
  assert_eq(f.parse_assignment("s SATISFIABLE\nv 1\nv -2 0").unwrap(), [
    false, true, false,
  ])
  for
    bad in [
      "s UNSATISFIABLE", "s SATISFIABLE\nv 1 0", "s SATISFIABLE\nv 1 -1 2 0", "s SATISFIABLE\nv -1 -2 0",
      "s SATISFIABLE\nv 1 2", "s SATISFIABLE\nv 1 2 0 1",
    ] {
    assert_true(f.parse_assignment(bad) is Err(_))
  }
}
