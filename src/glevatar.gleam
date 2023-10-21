import gleam/io
import gleam/map
import gleam/int
import gleam/bit_string
import gleam/uri
import gleam/option
import glesha

pub type GravatarBuilder =
  #(String, map.Map(String, String))

pub type DefaultImage {
  NotFound
  MysteryPerson
  Identicon
  MonsterId
  Wavatar
  Retro
  Robohash
  Blank
  CustomImage(String)
}

pub type ImageRating {
  General
  Parental
  Restricted
  Adult
}

pub fn new(email: String) -> GravatarBuilder {
  let hash =
    email
    |> bit_string.from_string()
    |> glesha.hash(glesha.Sha256)
    |> glesha.encode_hex()

  #(hash, map.new())
}

pub fn set_size(builder: GravatarBuilder, size: Int) -> GravatarBuilder {
  let #(hash, options) = builder
  #(hash, map.insert(options, "s", int.to_string(size)))
}

pub fn set_default_image(
  builder: GravatarBuilder,
  default: DefaultImage,
) -> GravatarBuilder {
  let #(hash, options) = builder
  let value = case default {
    NotFound -> "404"
    MysteryPerson -> "mp"
    Identicon -> "identicon"
    MonsterId -> "monsterid"
    Wavatar -> "wavatar"
    Retro -> "retro"
    Robohash -> "robohash"
    Blank -> "blank"
    CustomImage(url) -> url
  }

  #(hash, map.insert(options, "d", value))
}

pub fn set_rating(
  builder: GravatarBuilder,
  rating: ImageRating,
) -> GravatarBuilder {
  let #(hash, options) = builder
  let value = case rating {
    General -> "g"
    Parental -> "pg"
    Restricted -> "r"
    Adult -> "x"
  }

  #(hash, map.insert(options, "r", value))
}

pub fn to_uri(builder: GravatarBuilder) -> uri.Uri {
  let #(hash, options) = builder

  let path = "/avatar/" <> hash
  let query =
    options
    |> map.to_list
    |> uri.query_to_string

  uri.Uri(
    scheme: option.Some("https"),
    userinfo: option.None,
    host: option.Some("gravatar.com"),
    port: option.None,
    path: path,
    query: option.Some(query),
    fragment: option.None,
  )
}

pub fn to_string(builder: GravatarBuilder) -> String {
  builder
  |> to_uri()
  |> uri.to_string()
}

pub fn main() {
  "test@example.com"
  |> new()
  |> io.debug()
  |> set_size(600)
  |> io.debug()
  |> set_default_image(Wavatar)
  |> io.debug()
  |> set_rating(Parental)
  |> io.debug()
  |> to_string()
  |> io.debug()
}
