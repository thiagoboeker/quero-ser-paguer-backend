defmodule PagBackend.Api.Pedidos.Plug do
  @moduledoc false

  def init(opts), do: opts

  def call(conn, opts) do
    conn
    |> PagBackend.Api.Pedidos.Router.call(opts)
  end
end

defmodule PagBackend.Api.Pedidos.Router do
  @moduledoc false

  use Plug.Router
  alias PagBackend.Schema.Pedidos
  alias PagBackend.Api.DAO
  import PagBackend.Api
  import PagBackend.Dispatcher, only: [route: 1]

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  post route("/pedidos") do
    %Pedidos{}
    |> DAO.create(Pedidos, conn.body_params)
    |> handle_success(fn result ->
      send_resp(conn, 201, json_resp(success: true, data: result))
    end)
    |> handle_error(fn errors -> send_resp(conn, 400, json_resp(success: false, data: errors)) end)
  end

  get route("/pedidos/:id") do
    Pedidos
    |> DAO.show(id)
    |> DAO.preload(:items)
    |> handle_success(fn result ->
      send_resp(conn, 200, json_resp(success: true, data: result))
    end)
    |> handle_error(fn errors -> send_resp(conn, 400, json_resp(success: false, data: errors)) end)
  end

  put route("/pedidos/:id") do
    Pedidos
    |> DAO.show(id)
    |> DAO.preload(:items)
    |> DAO.update(Pedidos, conn.body_params)
    |> handle_success(fn result ->
      send_resp(conn, 200, json_resp(success: true, data: result))
    end)
    |> handle_error(fn errors -> send_resp(conn, 400, json_resp(success: false, data: errors)) end)
  end

  delete route("/pedidos/:id") do
    Pedidos
    |> DAO.delete(id)
    |> DAO.preload(:items)
    |> handle_success(fn result ->
      send_resp(conn, 200, json_resp(success: true, data: result))
    end)
    |> handle_error(fn errors -> send_resp(conn, 400, json_resp(success: false, data: errors)) end)
  end
end
