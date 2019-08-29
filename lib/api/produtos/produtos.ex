defmodule PagBackend.Api.Produtos.Plug do
  @moduledoc false

  def init(opts), do: opts

  def call(conn, opts) do
    conn
    |> PagBackend.Api.Produtos.Router.call(opts)
  end
end

defmodule PagBackend.Api.Produtos.Router do
  @moduledoc false

  use Plug.Router
  alias PagBackend.Api.DAO
  alias PagBackend.Schema.Produtos
  import PagBackend.Api
  import PagBackend.Dispatcher, only: [route: 1]

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  post route("/produtos") do
    %Produtos{}
    |> DAO.create(Produtos, conn.body_params)
    |> handle_success(fn result ->
      send_resp(conn, 200, json_resp(success: true, data: result))
    end)
    |> handle_error(fn errors -> send_resp(conn, 400, json_resp(success: false, data: errors)) end)
  end

  get route("/produtos/:id") do
    Produtos
    |> DAO.show(id)
    |> handle_success(fn result ->
      send_resp(conn, 200, json_resp(success: true, data: result))
    end)
    |> handle_error(fn errors -> send_resp(conn, 400, json_resp(success: false, data: errors)) end)
  end

  put route("/produtos/:id") do
    Produtos
    |> DAO.update(id, conn.body_params)
    |> handle_success(fn result ->
      send_resp(conn, 200, json_resp(success: true, data: result))
    end)
    |> handle_error(fn errors -> send_resp(conn, 400, json_resp(success: false, data: errors)) end)
  end

  delete route("/produtos/:id") do
    Produtos
    |> DAO.delete(id)
    |> handle_success(fn result ->
      send_resp(conn, 200, json_resp(success: true, data: result))
    end)
    |> handle_error(fn errors -> send_resp(conn, 400, json_resp(success: false, data: errors)) end)
  end
end
