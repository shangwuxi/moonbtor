///|
fn main {
  let m = @moonbtor.parse(
    "1 sort bitvec 2\n2 sort bitvec 1\n3 input 1 selection\n4 constd 1 2\n5 eq 2 3 4\n6 bad 5",
  ).unwrap()
  println(m.query(0).unwrap().formula().to_dimacs())
}
