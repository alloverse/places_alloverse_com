use Mix.Config

# Configure your database
config :places_alloverse_com, PlacesAlloverseCom.Repo,
  username: "postgres",
  password: "postgres",
  database: "places_alloverse_com_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :places_alloverse_com, PlacesAlloverseComWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
