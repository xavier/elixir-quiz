# This file is responsible for configuring your application
use Mix.Config

# Note this file is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project.

config :phoenix, Watercooler.Router,
  port: System.get_env("PORT"),
  ssl: false,
  static_assets: true,
  cookies: true,
  session_key: "_watercooler_key",
  session_secret: "J)GXC1Z#_)(6HKW7X0E^7L84CWB242EVM#3)911*G$OB&IEE0&G@+K00F5TT2@164=_+I=",
  catch_errors: true,
  debug_errors: false,
  error_controller: Watercooler.PageController

config :phoenix, :code_reloader,
  enabled: false

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. Note, this must remain at the bottom of
# this file to properly merge your previous config entries.
import_config "#{Mix.env}.exs"
