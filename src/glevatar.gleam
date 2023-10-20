import gleam/io

@external(erlang, "sha256", "sha256")
@external(javascript, "./sha256.mjs", "sha256")
fn sha256(input: String) -> String

pub fn main() {
  io.println(sha256("trying out"))
}
