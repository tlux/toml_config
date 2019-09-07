defmodule TomlConfigProvider do
  @moduledoc """
  A config provider to read [TOML](https://github.com/toml-lang/toml)
  configuration files that works with Elixir (1.9+) releases.

  ## Usage

  Update the release configuration in your mix.exs file:

  You can either give a fully qualified pathname to the config file.

      releases: [
        my_app: [
          config_providers: [
            {TomlConfigProvider, path: "/absolute/path/to/my/config.toml"}
          ],
          ...
        ]
      ]

  Or you can read the config path from a specified environment variable. Booting
  the application fails if the environment variable is undefined.

      releases: [
        my_app: [
          config_providers: [
            {TomlConfigProvider,
             path: {:system, "RELEASE_CONFIG_DIR", "my_app.toml"}}
          ],
          ...
        ]
      ]

  All config provider options except `:path` are forwarded to
  `Toml.decode_file/2`. Thus, you can also provide custom transforms.

      config_providers: [
        {TomlConfigProvider,
         path: "path/to/my/config.toml",
         transforms: [UrlTransform, TupleTransform]}
      ]
  """

  @behaviour Config.Provider

  alias TomlConfigProvider.FileNotFoundError

  @impl true
  def init(opts), do: opts

  @impl true
  def load(config, opts) do
    {:ok, _} = Application.ensure_all_started(:toml)

    {path, decode_opts} = Keyword.pop(opts, :path)
    decode_opts = Keyword.put(decode_opts, :keys, :atoms)

    data =
      path
      |> resolve_path()
      |> Path.expand()
      |> Toml.decode_file!(decode_opts)
      |> deep_convert_keyword()

    Config.Reader.merge(config, data)
  end

  defp resolve_path({:system, varname, filename}) do
    varname
    |> System.fetch_env!()
    |> Path.join(filename)
  end

  defp resolve_path({:system, varname}) do
    System.fetch_env!(varname)
  end

  defp resolve_path(path) when is_binary(path), do: path

  defp deep_convert_keyword(%_struct{} = term), do: term

  defp deep_convert_keyword(map) when is_map(map) do
    Keyword.new(map, fn {key, value} ->
      {key, deep_convert_keyword(value)}
    end)
  end

  defp deep_convert_keyword(term), do: term
end
