defmodule PagBackend.AwsTest do
  use ExUnit.Case
  alias PagBackend.Api.AWS

  defp gen_confirm_password(%{"Session" => session}, cliente) do
    cliente
    |> Map.put("parameter", "NEW_PASSWORD_REQUIRED")
    |> Map.put("session", session)
  end

  setup_all do
    cliente = Application.fetch_env!(:pag_backend, :cliente)
    AWS.aws_delete_user(cliente)
    {:ok, %{cliente: cliente}}
  end

  @tag authorization: true
  test "Authorization", context do
    {:ok, _user, _response} =
      AWS.aws_register_user_with_pass(context.cliente, context.cliente["password"])

    {:ok, challenge} = AWS.aws_init_auth(context.cliente)
    {:ok, auth} = AWS.aws_respond_challenge(gen_confirm_password(challenge, context.cliente))

    {:ok, {true, _data, _jws}} =
      AWS.aws_token_id_decode(
        {:ok, auth["AuthenticationResult"]["IdToken"]},
        AWS.aws_cognito_jwk()
      )
  end
end
