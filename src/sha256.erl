-module(sha256).

-export([sha256/1]).

-spec sha256(binary()) -> binary().
sha256(Input) ->
  <<Hash:256/big-unsigned-integer>> = crypto:hash(sha256, Input),
  lists:flatten(io_lib:format("~64.16.0b", [Hash])).
