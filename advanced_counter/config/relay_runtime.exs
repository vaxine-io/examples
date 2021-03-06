import Config

# Configure Antidote

config :advanced_counter, AdvancedCounter.Repos.Antidote,
  hostname:
    System.get_env("ANTIDOTE_DB_HOST") ||
      raise("Please specify `ANTIDOTE_DB_HOST` environment variable to connect to the database"),
  port: String.to_integer(System.get_env("ANTIDOTE_DB_PORT") || "8087")

# Configure CloudSQL
hostname = System.get_env("CLOUDSQL_DB_HOST")
socket_dir = System.get_env("CLOUDSQL_DB_SOCKET_DIR")
socket = System.get_env("CLOUDSQL_DB_SOCKET")

if !(hostname || socket_dir || socket),
  do:
    raise("""
    Please specify at least one environment variable to connect to the database:
      - use `CLOUDSQL_DB_HOST` to connect to the server hostname
      - use `CLOUDSQL_DB_SOCKET_DIR` to connect via a unix socket derived from the port
      - use `CLOUDSQL_DB_SOCKET` to connect via a unix socket in the given path
    """)

config :advanced_counter, AdvancedCounter.Repos.CloudSql,
  ssl: System.get_env("CLOUDSQL_DB_SSL", "true") == "true",
  username: System.get_env("CLOUDSQL_DB_USER") || "postgres",
  password: System.get_env("CLOUDSQL_DB_PASS"),
  port: String.to_integer(System.get_env("CLOUDSQL_DB_PORT") || "5432"),
  database:
    System.get_env("CLOUDSQL_DB_NAME") ||
      raise("Please specify a database with DB_NAME environment variable"),
  hostname: System.get_env("CLOUDSQL_DB_HOST"),
  socket_dir: System.get_env("CLOUDSQL_DB_SOCKET_DIR"),
  socket: System.get_env("CLOUDSQL_DB_SOCKET"),
  pool_size: String.to_integer(System.get_env("CLOUDSQL_POOL_SIZE") || "10")

# Configure CockroachDB
hostname = System.get_env("COCKROACH_DB_HOST")
socket_dir = System.get_env("COCKROACH_DB_SOCKET_DIR")
socket = System.get_env("COCKROACH_DB_SOCKET")

if !(hostname || socket_dir || socket),
  do:
    raise("""
    Please specify at least one environment variable to connect to the database:
      - use `COCKROACH_DB_HOST` to connect to the server hostname
      - use `COCKROACH_DB_SOCKET_DIR` to connect via a unix socket derived from the port
      - use `COCKROACH_DB_SOCKET` to connect via a unix socket in the given path
    """)

config :advanced_counter, AdvancedCounter.Repos.Cockroach,
  ssl: System.get_env("COCKROACH_DB_SSL", "true") == "true",
  username: System.get_env("COCKROACH_DB_USER") || "postgres",
  password: System.get_env("COCKROACH_DB_PASS"),
  port: String.to_integer(System.get_env("COCKROACH_DB_PORT") || "5432"),
  database:
    System.get_env("COCKROACH_DB_NAME") ||
      raise("Please specify a database with DB_NAME environment variable"),
  hostname: System.get_env("COCKROACH_DB_HOST"),
  socket_dir: System.get_env("COCKROACH_DB_SOCKET_DIR"),
  socket: System.get_env("COCKROACH_DB_SOCKET"),
  pool_size: String.to_integer(System.get_env("COCKROACH_POOL_SIZE") || "10")

# The secret key base is used to sign/encrypt cookies and other secrets.
# A default value is used in config/dev.exs and config/test.exs but you
# want to use a different value for prod and you most likely don't want
# to check this value into version control, so we use an environment
# variable instead.
secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :advanced_counter_relay, AdvancedCounterRelay.Endpoint,
  http: [
    # Enable IPv6 and bind on all interfaces.
    # Set it to  {0, 0, 0, 0, 0, 0, 0, 1} for local network only access.
    ip: {0, 0, 0, 0, 0, 0, 0, 0},
    port: String.to_integer(System.get_env("RELAY_PORT") || System.get_env("PORT") || "4000")
  ],
  secret_key_base: secret_key_base

if System.get_env("PHX_SERVER") do
  config :advanced_counter_relay, AdvancedCounterRelay.Endpoint, server: true
end
