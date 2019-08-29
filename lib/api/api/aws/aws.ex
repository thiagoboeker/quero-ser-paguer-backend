defmodule PagBackend.Api.AWS do
  @moduledoc """
  Esse modulo contem o dominio/interface das funcionalidades da AWS dentro da API
  > Note: Para as funcoes que interagem com o API cognito, cheque as regras de parametrizacao 
  declaradas na criacao do pool/cliente.
  """

  alias AWS.Cognito.IdentityProvider, as: AwsID
  alias PagBackend.Api.Aws.Login
  alias PagBackend.Api.Aws.Client
  alias PagBackend.Api.Aws.Account

  @doc """
  Funcao para registrar um usuario dentro do AWS Cognito
  """
  def aws_register_user(params) do
    Account.aws_client()
    |> AwsID.admin_create_user(Client.create_client(params))
    |> register_resp()
  end

  @doc """
  Registra um usuario com o password temporario especificado
  """
  def aws_register_user_with_pass(params, pass) do
    Account.aws_client()
    |> AwsID.admin_create_user(Client.create_client_temp_pass(params, pass))
    |> register_resp()
  end

  @doc """
  Delete um usuario do Cognito
  """
  def aws_delete_user(params) do
    Account.aws_client()
    |> AwsID.admin_delete_user(Client.delete_client(params))
    |> register_resp()
  end

  @doc """
  Inicia o processo de autenticacao do usuario. O parametro de autenticacao é **USER_PASSWORD_AUTH**. 
  Por default para primeiro login com o password temporario, se o usuario estiver com o status de FORCE_CHANGE_PASSWORD
  essa funcao retorna um Challenge para ser requisitado a mudanca de senha para o cliente com a funcao 
  `aws_respond_challenge/1`. 
  Caso contrario retorna as devidas tokens.
  """
  def aws_init_auth(params) do
    with {:ok, data, _response} <-
           AwsID.initiate_auth(Account.aws_client(), Login.create_init_auth(params)) do
      {:ok, data}
    else
      error -> register_resp(error)
    end
  end

  @doc """
  Decodifica o IdToken do usuario para prosseguir com a autenticacao
  """
  def aws_token_id_decode({:ok, token}, jwk) do
    Login.token_id_decode(jwk, token)
  end

  @doc false
  def aws_token_id_decode(error, _jwk), do: error

  @doc false
  def aws_cognito_jwk() do
    Login.jwk()
  end

  @doc """
  Responde o challenge do processo de autenticacao. Para a v1 essa funcao atende apenas ao parametro 
  **NEW_PASSWORD_REQUIRED**
  """
  def aws_respond_challenge(params) do
    %{"parameter" => parameter} = params

    with {:ok, data, _response} <- Login.respond_challenge(parameter, params) do
      {:ok, data}
    else
      {:error, error} -> {:exception, handle_error(error)}
    end
  end

  @doc false
  def handle_error({reason, msg}), do: %{reason: reason, msg: msg}

  @doc false
  defp register_resp({:error, description}),
    do: {:exception, %{success: false, errors: handle_error(description)}}

  @doc false
  defp register_resp({:ok, _data, _response} = resp), do: resp
end

defmodule PagBackend.Api.Aws.Account do
  @moduledoc """
  Modulo responsavel pela interface da conta de servico da AWS
  """

  @access_key_id Application.fetch_env!(:pag_backend, :access_key_id)
  @secret_access_id Application.fetch_env!(:pag_backend, :secret_access_key)
  @aws_region Application.fetch_env!(:pag_backend, :aws_region)

  @doc """
  Retorna um objeto AWS.Client para ser usado em chamadas da API da AWS.
  """
  def aws_client() do
    %AWS.Client{
      access_key_id: @access_key_id,
      secret_access_key: @secret_access_id,
      region: @aws_region,
      endpoint: "amazonaws.com"
    }
  end
end
