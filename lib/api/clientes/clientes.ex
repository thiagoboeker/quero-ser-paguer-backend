defmodule PagBackend.Api.Clientes.Plug do
  @moduledoc false

  use Plug.Builder

  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)

  def init(opts), do: opts

  def call(conn, opts) do
    conn
    |> super([])
    |> PagBackend.Api.Clientes.Router.call(opts)
  end
end

defmodule PagBackend.Api.Clientes.Authorizer do
  @moduledoc false

  defmacro __using__(_) do
    quote do
      alias PagBackend.Api.AWS, as: AwsAPI
      alias PagBackend.Api.DAO
      alias PagBackend.Schema.Clientes
      import Plug.Conn
      import PagBackend.Api

      defp get_resource(jws, %{path_params: %{"id" => id}}) do
        with {:ok, result} <- DAO.show(Clientes, id) do
          {:ok, Tuple.append(jws, result)}
        else
          _ -> {:error, "RESOURCE NOT FOUND"}
        end
      end

      defp check_http_method(conn, methods \\ ["GET", "PUT", "DELETE"]) do
        if Enum.any?(methods, fn m -> conn.method == m end) do
          :included
        else
          :not_included
        end
      end

      defp evaluate_credentials({:ok, creds}, conn) do
        IO.inspect(current_timestamp())
        IO.inspect(creds)

        with {:ok, {true, data, jws}, resource} <- creds do
          cond do
            data["email"] == resource.email and current_timestamp() <= data["exp"] -> conn
            true -> halt(conn)
          end
        else
          _ -> halt(conn)
        end
      end

      defp authorize(var!(_conn) = c, _opts) do
        with :included <- check_http_method(c) do
          get_authorization_header(c)
          |> AwsAPI.aws_token_id_decode(AwsAPI.aws_cognito_jwk())
          |> get_resource(c)
          |> evaluate_credentials(c)
          |> check_halted_conn(fn connection -> send_resp(connection, 401, "Unauthorized") end)
        else
          _ -> c
        end
      end
    end
  end
end

defmodule PagBackend.Api.Clientes.Auth do
  @moduledoc """
  Autentica o cliente
  """

  use Plug.Router
  import PagBackend.Api
  import PagBackend.Dispatcher, only: [route: 1]
  alias PagBackend.Api.AWS, as: AwsAPI

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  post route("/auth/cliente/login") do
    AwsAPI.aws_init_auth(conn.body_params)
    |> handle_success(fn result -> send_resp(conn, 200, Poison.encode!(result)) end)
    |> handle_error(fn errors -> send_resp(conn, 400, Poison.encode!(errors)) end)
  end

  post route("/auth/cliente/signup") do
    AwsAPI.aws_respond_challenge(conn.body_params)
    |> handle_success(fn result -> send_resp(conn, 200, Poison.encode!(result)) end)
    |> handle_error(fn errors -> send_resp(conn, 400, Poison.encode!(errors)) end)
  end
end

defmodule PagBackend.Api.Clientes.Router do
  @moduledoc false

  use Plug.Router
  use PagBackend.Api.Clientes.Authorizer
  import PagBackend.Api
  import PagBackend.Dispatcher, only: [route: 1]

  alias PagBackend.Api.DAO
  alias PagBackend.Schema.Clientes
  alias PagBackend.Api.AWS, as: AwsAPI

  plug(:match)
  plug(:authorize)
  plug(:dispatch)

  post route("/clientes") do
    %Clientes{}
    |> DAO.create(Clientes, conn.params)
    |> register_user(conn)
    |> handle_success(fn result -> send_resp(conn, 200, Poison.encode!(result)) end)
    |> handle_error(fn errors -> send_resp(conn, 400, Poison.encode!(errors)) end)
  end

  get route("/clientes/:id") do
    Clientes
    |> DAO.show(id)
    |> handle_success(fn result -> send_resp(conn, 200, Poison.encode!(result)) end)
    |> handle_error(fn errors -> send_resp(conn, 400, Poison.encode!(errors)) end)
  end

  put route("/clientes/:id") do
    Clientes
    |> DAO.update(id, conn.params)
    |> handle_success(fn result -> send_resp(conn, 200, Poison.encode!(result)) end)
    |> handle_error(fn errors -> send_resp(conn, 400, Poison.encode!(errors)) end)
  end

  delete route("/clientes/:id") do
    Clientes
    |> DAO.delete(id)
    |> handle_success(fn result -> send_resp(conn, 200, Poison.encode!(result)) end)
    |> handle_error(fn errors -> send_resp(conn, 400, Poison.encode!(errors)) end)
  end

  defp register_user(op, conn) do
    with {:ok, result} <- op do
      case AwsAPI.aws_register_user(conn.body_params) do
        {:ok, _data, _response} ->
          {:ok, result}

        err ->
          DAO.delete(result)
          err
      end
    else
      _ -> op
    end
  end
end
