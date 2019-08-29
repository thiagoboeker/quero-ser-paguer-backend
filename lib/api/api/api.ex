defmodule PagBackend.Api do
  @moduledoc """
  Helper com funcoes gerais para auxiliar na construção dos modulos.  
  """

  import Ecto.Changeset

  @doc """
  Checa para resposta a requisições bem sucedidas
  """
  def handle_success(op, fun) do
    with {:ok, result} <- op do
      fun.(result)
    else
      _ -> op
    end
  end

  @doc """
  Checa para erros na requisição, agrupa os erros e invoca o callback passado.
  """
  def handle_error(op, fun) do
    with {:error, result} <- op do
      errors = traverse_errors_(result)
      fun.(errors)
    else
      {:exception, error} -> fun.(error)
      _ -> op
    end
  end

  @doc """
  Atravessa os erros gerados pelo changeset substituindo as variaves.
  """
  def traverse_errors_(errors) do
    traverse_errors(errors, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, acc ->
        String.replace(acc, "{{#{key}}}", to_string(value))
      end)
    end)
  end

  @doc """
  Verifica para o header de Authorization e Splita o Bearer retornando a token.
  """
  def get_authorization_header(conn) do
    Enum.filter(conn.req_headers, fn {header, _} -> header == "authorization" end)
    |> Enum.at(0, {:error, %{error: "MISSING AUTHORIZATION HEADER"}})
    |> strip_token_auth()
  end

  defp strip_token_auth(auth) do
    with {"authorization", token} <- auth do
      t = String.split(token) |> Enum.at(1)
      {:ok, t}
    else
      _ -> auth
    end
  end

  @doc """
  Checa por um halt em uma requisicao que foi invalidada.
  """
  def check_halted_conn(conn, fun) do
    cond do
      conn.halted -> fun.(conn)
      true -> conn
    end
  end

  @doc false
  def current_timestamp() do
    :os.system_time(:seconds)
  end

  @doc false
  def json_resp(success: success, data: data), do: Poison.encode!(%{success: success, data: data})
end
