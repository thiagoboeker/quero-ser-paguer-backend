use Mix.Config

config :pag_backend, :app_client_id, "1gau0e9l28dkcamlb4r9o6eap4"
config :pag_backend, :cognito_user_pool_id, "us-east-1_rvcNqv4gX"
config :pag_backend, :access_key_id, "AKIAJBKH5TLZ27MJUJVQ"
config :pag_backend, :secret_access_key, "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"
config :pag_backend, :aws_region, "us-east-1"
config :pag_backend, :version, "/api/v1"

config :pag_backend,
       :cognito_jwk_path,
       "C:\\Users\\thiag\\elixir\\pag_backend\\lib\\api\\api\\aws\\jwk.json"

config :pag_backend, ecto_repos: [PagBackend.Repo]

config :pag_backend, PagBackend.Repo,
  database: "pagbackend_test",
  username: "postgres",
  password: "postgres",
  hostname: "127.0.0.1",
  migration_timestamps: [type: :utc_datetime]

config :pag_backend,
       :cliente,
       Map.new()
       |> Map.put("nome", "Client Test")
       |> Map.put("data_nascimento", "1992-04-16")
       |> Map.put("cpf", "123123132")
       |> Map.put("email", "pagbackend@gmail.com")
       |> Map.put("username", "pagbackend")
       |> Map.put("password", "PagBackend2*")

config :pag_backend,
       :produto,
       Map.new()
       |> Map.put("nome", "Coxinha")
       |> Map.put("preco_sugerido", 1000.0)
