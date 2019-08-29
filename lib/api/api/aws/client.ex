defmodule PagBackend.Api.Aws.Client do
  @moduledoc """
  API para gerenciar usuarios do Cognito.
  """

  @cognito_user_pool_id Application.fetch_env!(:pag_backend, :cognito_user_pool_id)

  @doc """
  Cria um cliente para ser inserido na UserPool
  """
  def create_client(%{"username" => username, "email" => email}) do
    Map.new()
    |> Map.put(:UserAttributes, [%{Name: "email", Value: email}])
    |> Map.put(:Username, username)
    |> Map.put(:UserPoolId, @cognito_user_pool_id)
  end

  @doc """
  Mesma coisa que `create_client/1` porem pode ser configurado um password temporario especifico.
  """
  def create_client_temp_pass(params, password) do
    create_client(params)
    |> Map.put(:TemporaryPassword, password)
  end

  @doc """
  Cria o objeto para deletar o cliente.
  """
  def delete_client(%{"username" => username}) do
    Map.new()
    |> Map.put(:Username, username)
    |> Map.put(:UserPoolId, @cognito_user_pool_id)
  end
end
