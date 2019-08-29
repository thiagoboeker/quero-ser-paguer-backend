defmodule PagBackend.Api.Aws.Login do
  @moduledoc """
  API para login e autenticacao dos clientes.
  """

  @app_client_id Application.fetch_env!(:pag_backend, :app_client_id)
  @cognito_user_pool_id Application.fetch_env!(:pag_backend, :cognito_user_pool_id)
  @cognito_jwk_path Application.fetch_env!(:pag_backend, :cognito_jwk_path)

  alias AWS.Cognito.IdentityProvider, as: AwsID
  alias PagBackend.Api.Aws.Account

  @doc false
  def create_init_auth(%{"username" => username, "password" => password}) do
    Map.new()
    |> Map.put(:AuthFlow, "USER_PASSWORD_AUTH")
    |> Map.put(:ClientId, @app_client_id)
    |> Map.put(
      :AuthParameters,
      Map.new()
      |> Map.put(:USERNAME, username)
      |> Map.put(:PASSWORD, password)
    )
  end

  @doc false
  def create_challenge_response(
        "NEW_PASSWORD_REQUIRED" = challengeName,
        password,
        username,
        session
      ) do
    Map.new()
    |> Map.put(:ChallengeName, challengeName)
    |> Map.put(
      :ChallengeResponses,
      Map.new() |> Map.put(:NEW_PASSWORD, password) |> Map.put(:USERNAME, username)
    )
    |> Map.put(:ClientId, @app_client_id)
    |> Map.put(:UserPoolId, @cognito_user_pool_id)
    |> Map.put(:Session, session)
  end

  @doc """
  Responde ao challenge NEW_PASSWORD_REQUIRED com o novo password do cliente.
  """
  def respond_challenge(
        "NEW_PASSWORD_REQUIRED",
        %{"password" => password, "username" => username, "session" => session}
      ) do
    AwsID.admin_respond_to_auth_challenge(
      Account.aws_client(),
      create_challenge_response("NEW_PASSWORD_REQUIRED", password, username, session)
    )
  end

  @doc """
  Decodifica o IdToken recebido.
  """
  def token_id_decode(jwk, token) do
    try do
      JOSE.JWT.peek_protected(token)
      |> filter_by_kid(jwk)
      |> JOSE.JWS.verify(token)
      |> decode()
    rescue
      _ -> {:error, "DECODE ERROR"}
    end
  end

  defp decode({true, body, jws}) do
    {:ok, {true, Poison.decode!(body), jws}}
  end

  @doc false
  defp filter_by_kid(jws, jwk) do
    with %{fields: %{"kid" => kid}} <- jws do
      jwk
      |> Enum.filter(fn {:jose_jwk, _fields, _keys, kty} -> kty["kid"] == kid end)
      |> Enum.at(0)
    end
  end

  @doc """
  Retorna as keys do JWK baixado do link de referencia da UserPool do projeto.  
  O caminho usado esta configurado no ambiente como cognito_jwk_path.
  """
  def jwk() do
    %{fields: _fields, keys: jose_set} = JOSE.JWK.from_file(@cognito_jwk_path)
    {:jose_jwk_set, keys} = jose_set
    keys
  end
end
