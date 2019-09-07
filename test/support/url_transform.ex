defmodule UrlTransform do
  use Toml.Transform

  def transform(:dsn, url) when is_binary(url) do
    URI.parse(url)
  end

  def transform(_k, v), do: v
end
