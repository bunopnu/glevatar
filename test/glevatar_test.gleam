import gleeunit
import gleeunit/should
import gleam/map
import glevatar

pub fn main() {
  gleeunit.main()
}

pub fn basic_builder_test() {
  let got = glevatar.new("test@example.com")
  let expected = #(
    "973dfe463ec85785f5f95af5ba3906eedb2d931c24e69824a89ea65dba4e813b",
    map.new(),
  )

  should.equal(got, expected)
}

pub fn basic_url_test() {
  let got =
    "test@example.com"
    |> glevatar.new()
    |> glevatar.to_string()

  let expected =
    "https://gravatar.com/avatar/973dfe463ec85785f5f95af5ba3906eedb2d931c24e69824a89ea65dba4e813b?"

  should.equal(got, expected)
}

pub fn complex_url_test() {
  let got =
    "test@example.com"
    |> glevatar.new()
    |> glevatar.set_size(400)
    |> glevatar.set_default_image(glevatar.Blank)
    |> glevatar.set_rating(glevatar.Adult)
    |> glevatar.to_string()

  let expected =
    "https://gravatar.com/avatar/973dfe463ec85785f5f95af5ba3906eedb2d931c24e69824a89ea65dba4e813b?d=blank&r=x&s=400"

  should.equal(got, expected)
}
