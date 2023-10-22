# Glevatar

[![Test Status](https://github.com/bunopnu/glevatar/actions/workflows/test.yml/badge.svg)](https://github.com/bunopnu/glevatar/actions/workflows/test.yml)
[![Package Version](https://img.shields.io/hexpm/v/glevatar)](https://hex.pm/packages/glevatar)
[![Hex Docs](https://img.shields.io/badge/hex-docs-ffaff3)](https://hexdocs.pm/glevatar/)

Easily create Gravatar URLs in Gleam, supporting both Erlang and JavaScript 🎀

## Installation

To add the library, simply execute the following command:

```sh
gleam add glevatar
```

## Example

```gleam
"bob@example.com"
|> glevatar.new()
|> glevatar.set_size(400)
|> glevatar.to_string()
// "https://gravatar.com/avatar/5ff860bf1190596c7188ab851db691f0f3169c453936e9e1eba2f9a47f7a0018?s=400"
```

## Documentation

Consult the [HexDocs](https://hexdocs.pm/glavatar/) for API reference.

## License

Glevatar is licensed under the MIT license.
