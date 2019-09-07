# TOML Config Provider

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

## Docs

Documentation can be generated with
[ExDoc](https://github.com/elixir-lang/ex_doc) and is published on
[HexDocs](https://hexdocs.pm/toml_config).

