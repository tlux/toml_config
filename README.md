# TOML Config Provider

[![Build Status](https://travis-ci.org/tlux/toml_config.svg?branch=master)](https://travis-ci.org/tlux/toml_config)
[![Coverage Status](https://coveralls.io/repos/github/tlux/toml_config/badge.svg?branch=master)](https://coveralls.io/github/tlux/toml_config?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/toml_config.svg)](https://hex.pm/packages/toml_config)

A config provider to read [TOML](https://github.com/toml-lang/toml)
configuration files that works with Elixir (1.9+) releases.

Note: If you are building releases with Distillery, you can use the config
provider from the [toml-elixir](https://github.com/bitwalker/toml-elixir)
library.

## Prerequisites

* Elixir >= 1.9

## Installation

The package can be installed by adding `toml_config` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:toml_config, "~> 0.1"}
  ]
end
```

## Usage

Update the release configuration in your mix.exs file:

You can either give a fully qualified pathname to the config file.

```elixir
releases: [
  my_app: [
    config_providers: [
      {TomlConfigProvider, path: "/absolute/path/to/my/config.toml"}
    ],
    ...
  ]
]
```

Or you can read the config directory or path from a specified environment
variable. Booting the application fails if the specified environment variable is
undefined.

```elixir
releases: [
  my_app: [
    config_providers: [
      {TomlConfigProvider,
       path: {:system, "RELEASE_CONFIG_DIR", "my_app.toml"}}
    ],
    ...
  ]
]
```

Or:

```elixir
releases: [
  my_app: [
    config_providers: [
      {TomlConfigProvider, path: {:system, "RELEASE_CONFIG_PATH"}}
    ],
    ...
  ]
]
```

All config provider options except `:path` are forwarded to `Toml.decode_file/2`
from the [toml-elixir](https://github.com/bitwalker/toml-elixir) library. Thus,
you can also provide custom transforms.


```elixir
config_providers: [
  {TomlConfigProvider,
   path: "path/to/my/config.toml",
   transforms: [UrlTransform, TupleTransform]}
]
```

## Other Implementations

### `toml` Config Provider

The [toml](https://hex.pm/packages/toml) package brings it's own config provider
that unfortunately only works with
[distellery](https://github.com/bitwalker/distillery) releases at the moment.

### `toml_config_provider`

Unlike [toml_config_provider](https://hex.pm/packages/toml_config_provider),
this library allows specifying the location of the config file through
environment variables. This is quite useful when you have multiple (slightly
different) instances of a release running on the same machine, such as staging
and production environments. Additionally, we allow custom transform modules.

## Docs

Documentation can be generated with
[ExDoc](https://github.com/elixir-lang/ex_doc) and is published on
[HexDocs](https://hexdocs.pm/toml_config).

