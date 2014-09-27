use Mix.Config

config :phoenix, Watercooler.Router,
  port: System.get_env("PORT") || 4001,
  ssl: false,
  cookies: true,
  session_key: "_watercooler_key",
  session_secret: "J)GXC1Z#_)(6HKW7X0E^7L84CWB242EVM#3)911*G$OB&IEE0&G@+K00F5TT2@164=_+I="

config :phoenix, :code_reloader,
  enabled: true

config :logger, :console,
  level: :debug


