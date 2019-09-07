defmodule TomlConfigProvider do
  @moduledoc """
  A custom config provider to load TOML files for configuration.
  """

  @behaviour Config.Provider

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

  defp resolve_path(path) when is_binary(path), do: path

  defp deep_convert_keyword(%_struct{} = term), do: term

  defp deep_convert_keyword(map) when is_map(map) do
    Keyword.new(map, fn {key, value} ->
      {key, deep_convert_keyword(value)}
    end)
  end

  defp deep_convert_keyword(term), do: term
end
