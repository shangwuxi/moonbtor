///|
fn main {
  let m = @moonbtor.parse(
    "1 sort bitvec 1\n2 zero 1\n3 state 1\n4 init 1 3 2\n5 not 1 3\n6 next 1 3 5\n7 fair 3\n8 justice 2 3 5",
  ).unwrap()
  let q = m.lasso_query(2, 0, justice_index=Some(0)).unwrap()
  match q.formula().solve() {
    Satisfiable(a) => {
      let trace = q.decode_typed(a).unwrap()
      ignore(m.replay_typed(trace).unwrap())
      println("fair lasso: 0 -> 1 -> 0; both justice goals recur")
    }
    _ => panic()
  }
}
