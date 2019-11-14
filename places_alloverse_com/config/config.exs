# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :places_alloverse_com,
  ecto_repos: [PlacesAlloverseCom.Repo]

# Configures the endpoint
config :places_alloverse_com, PlacesAlloverseComWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "0I7OIsK/bUWKn1q9Qj54cYjHnWPhsU/c2S/g9eWSMqLvRYsWTIX9u9Wkf5ZsyH3W",
  render_errors: [view: PlacesAlloverseComWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: PlacesAlloverseCom.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
