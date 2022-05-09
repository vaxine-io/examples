import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :advanced_counter, AdvancedCounter.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "advanced_counter_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :advanced_counter_web, AdvancedCounterWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "mpr0RloNPVi3NrXkdAGAe3z3yBpemvv8uxlD79W6TsE6ABJa5i1j+j6SHPI3/xNk",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime