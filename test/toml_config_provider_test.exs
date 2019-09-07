defmodule TomlConfigProviderTest do
  use ExUnit.Case
  doctest TomlConfigProvider

  test "greets the world" do
    assert TomlConfigProvider.hello() == :world
  end
end
