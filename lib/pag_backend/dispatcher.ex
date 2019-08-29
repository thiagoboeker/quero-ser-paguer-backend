defmodule PagBackend.Dispatcher do
  @moduledoc """
  Modulo responsavel pela multiplexação das rotas da API
  """

  @api_version Application.fetch_env!(:pag_backend, :version)

  @doc """
  Funcao que contem a logica das rotas da API
  """
  def dispatch() do
    [
      {:_,
       [
         {route("/auth/cliente/[...]"), Plug.Cowboy.Handler, {PagBackend.Api.Clientes.Auth, []}},
         {route("/clientes"), Plug.Cowboy.Handler, {PagBackend.Api.Clientes.Plug, []}},
         {route("/clientes/[...]"), Plug.Cowboy.Handler, {PagBackend.Api.Clientes.Plug, []}},
         {route("/produtos"), Plug.Cowboy.Handler, {PagBackend.Api.Produtos.Plug, []}},
         {route("/produtos/[...]"), Plug.Cowboy.Handler, {PagBackend.Api.Produtos.Plug, []}},
         {route("/pedidos"), Plug.Cowboy.Handler, {PagBackend.Api.Pedidos.Plug, []}},
         {route("/pedidos/[...]"), Plug.Cowboy.Handler, {PagBackend.Api.Pedidos.Plug, []}}
       ]}
    ]
  end

  @doc """
  Gera as rotas da api com a versao apropriada.
  """
  def route(path) do
    @api_version <> path
  end
end
