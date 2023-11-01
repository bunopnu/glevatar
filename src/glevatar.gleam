//// Easily create Gravatar URLs in Gleam.

import gleam/map
import gleam/int
import gleam/bit_array
import gleam/uri
import gleam/option
import glesha

/// This type defines a Gravatar builder, which should not be manually modified.
pub type GravatarBuilder =
  #(String, map.Map(String, String))

/// This type is employed when the provided email address does not correspond to any Gravatar image.
pub type DefaultImage {
  /// Signifies that no image should be loaded.
  NotFound
  /// Represents a simple, cartoon-style silhouetted outline of a person.
  MysteryPerson
  /// Depicts a geometric pattern based on an email hash.
  Identicon
  /// Denotes a generated "monster" with various colours and facial features.
  MonsterId
  /// Represents generated faces with distinct features and backgrounds.
  Wavatar
  /// Displays artistically generated, 8-bit arcade-style pixelated faces.
  Retro
  /// Signifies a generated robot with different colours, faces, and so on.
  Robohash
  /// Denotes a transparent PNG image.
  Blank
  /// Indicates a custom default image fetched from a URL.
  CustomImage(String)
}

/// This type is used for specifying image ratings.
pub type ImageRating {
  /// Suitable for display on all websites.
  General
  /// May contain mild elements such as rude gestures, provocatively dressed individuals, or mild violence.
  Parental
  /// May contain stronger elements such as harsh profanity, intense violence, nudity, or hard drug use.
  Restricted
  /// May contain explicit content, including hardcore sexual imagery or extremely disturbing violence.
  Adult
}

/// Create a new `GravatarBuilder` based on an email address.
pub fn new(email: String) -> GravatarBuilder {
  let hash =
    email
    |> bit_array.from_string()
    |> glesha.hash(glesha.Sha256)
    |> glesha.encode_hex()

  #(hash, map.new())
}

/// Set a specific image size; the default is `80`.
pub fn set_size(builder: GravatarBuilder, size: Int) -> GravatarBuilder {
  let #(hash, options) = builder
  #(hash, map.insert(options, "s", int.to_string(size)))
}

/// Set the default image to be used when the provided email address doesn't match any image.
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

/// Set image rating restrictions.
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

/// Convert the `GravatarBuilder` into an Uri structure.
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

/// Convert the `GravatarBuilder` into a Gravatar image URL.
pub fn to_string(builder: GravatarBuilder) -> String {
  builder
  |> to_uri()
  |> uri.to_string()
}
