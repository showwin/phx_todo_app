# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :phx_todo_app,
  ecto_repos: [PhxTodoApp.Repo]

# Configures the endpoint
config :phx_todo_app, PhxTodoAppWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "phxbI/ZqEtcjn/m9PQ2z9NzsAZnJ2k/nnxgzjud156/z+xiJ/hhJzcEzHp4j8Xc2",
  render_errors: [view: PhxTodoAppWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: PhxTodoApp.PubSub,
  live_view: [signing_salt: "s3GsPyu9"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
