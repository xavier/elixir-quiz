use Mix.Config

# NOTE: To get SSL working, you will need to set:
#
#     ssl: true,
#     keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#     certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#
# Where those two env variables point to a file on disk
# for the key and cert

config :phoenix, Watercooler.Router,
  port: System.get_env("PORT"),
  ssl: false,
  host: "example.com",
  cookies: true,
  session_key: "_watercooler_key",
  session_secret: "J)GXC1Z#_)(6HKW7X0E^7L84CWB242EVM#3)911*G$OB&IEE0&G@+K00F5TT2@164=_+I="

config :logger, :console,
  level: :info,
  metadata: [:request_id]

