defmodule TomlConfigProviderTest do
  @moduledoc false

  use ExUnit.Case, async: false

  describe "init/1" do
    test "get string path" do
      path = "config/example.toml"
      opts = [path: path, transforms: []]

      assert TomlConfigProvider.init(opts) == opts
    end
  end

  describe "load/2" do
    @config [
      sentry: [
        dsn: "http://exampleurl.com"
      ],
      my_app: [
        hosting_env: "foo",
        another_key: "value"
      ]
    ]

    @merged_config [
      my_app: [another_key: "value", hosting_env: "example"],
      sentry: [
        dsn: "https://token@sentry.myurl.com",
        enable_source_code_context: true,
        environment_name: "example",
        hackney_opts: [ssl_options: [cacertfile: "/path/to/getsentry.pem"]],
        included_environments: "example",
        root_source_code_path: "/app/example"
      ]
    ]

    test "merge example config with string path" do
      opts = TomlConfigProvider.init(path: "test/fixtures/config.toml")

      assert TomlConfigProvider.load(@config, opts) == @merged_config
    end

    test "merge example config with env var path" do
      :ok = System.put_env("MY_CONFIG_PATH", "test/fixtures")
      on_exit(fn -> System.delete_env("MY_CONFIG_PATH") end)

      opts =
        TomlConfigProvider.init(
          path: {:system, "MY_CONFIG_PATH", "config.toml"}
        )

      assert TomlConfigProvider.load(@config, opts) == @merged_config
    end

    test "apply transforms" do
      opts =
        TomlConfigProvider.init(
          path: "test/fixtures/config.toml",
          transforms: [UrlTransform]
        )

      loaded_config = TomlConfigProvider.load(@config, opts)

      assert loaded_config[:sentry][:dsn] ==
               URI.parse(@merged_config[:sentry][:dsn])
    end
  end
end
