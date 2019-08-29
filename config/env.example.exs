use Mix.Config

config :pag_backend, :app_client_id, "xxxxxxxxxxxxxxxxxxxxxx"
config :pag_backend, :cognito_user_pool_id, "xxxxxxxxxxxxxxxxxxxx"
config :pag_backend, :access_key_id, "xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
config :pag_backend, :secret_access_key, "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
config :pag_backend, :aws_region, "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
config :pag_backend, :version, "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

config :pag_backend, :cognito_jwk_path, "xxxxxxxxxxxxxxxxxxxx"

config :pag_backend, ecto_repos: [PagBackend.Repo]

config :pag_backend, PagBackend.Repo,
  database: "xxxxxxxxxx",
  username: "xxxxxxxxxx",
  password: "xxxxxxxxxx",
  hostname: "127.0.0.1",
  migration_timestamps: [type: :utc_datetime]
