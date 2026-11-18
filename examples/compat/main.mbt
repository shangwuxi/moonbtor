///|
fn main {
  let source = @env.get_env_var("MOONBTOR_SOURCE").unwrap()
  let m = @moonbtor.parse(source).unwrap()
  println(
    "nodes=\{m.node_count()} states=\{m.typed_state_ports().length()} inputs=\{m.typed_input_ports().length()} bad=\{m.bad_count()}",
  )
}
