defmodule PagBackend.ClientesTest do
  use ExUnit.Case
  alias PagBackend.Api.DAO
  alias PagBackend.Schema.Clientes
  alias PagBackend.Schema.Produtos
  alias PagBackend.Schema.Pedidos
  alias PagBackend.Schema.ItemPedidos
  alias PagBackend.Repo

  setup_all do
    vars =
      Enum.into([:cliente, :produto], %{}, fn type ->
        {type, Application.fetch_env!(:pag_backend, type)}
      end)

    {:ok, vars}
  end

  defp clean_db(_context) do
    Repo.delete_all(ItemPedidos)
    Repo.delete_all(Pedidos)
    Repo.delete_all(Clientes)
    Repo.delete_all(Produtos)
    :ok
  end

  defp generate_pedido(id_cliente, produtos) when is_list(produtos) do
    items =
      Enum.map(produtos, fn prod ->
        Map.new()
        |> Map.put(:id_produto, prod[:id])
        |> Map.put(:quantidade, prod[:qtd])
        |> Map.put(:preco, prod[:preco])
      end)

    Map.new()
    |> Map.put(:id_cliente, id_cliente)
    |> Map.put(:items, items)
  end

  @tag client_crud: true
  test "Cliente CRUD", context do
    {:ok, inserted} = DAO.create(%Clientes{}, Clientes, context[:cliente])
    {:ok, _} = DAO.show(Clientes, inserted.id)
    {:ok, updated} = DAO.update(Clientes, inserted.id, %{nome: "Client Test 2"})
    assert(updated.nome == "Client Test 2")
    {:error, _} = DAO.create(%Clientes{}, Clientes, context[:cliente])
    {:ok, _} = DAO.delete(Clientes, updated.id)
  end

  @tag produto_crud: true
  test "Produto CRUD", context do
    produto = Map.fetch!(context, :produto)
    {:ok, inserted} = DAO.create(%Produtos{}, Produtos, produto)
    {:ok, _} = DAO.show(Produtos, inserted.id)
    {:ok, updated} = DAO.update(Produtos, inserted.id, %{nome: "Pastel"})
    assert(updated.nome == "Pastel")
    {:ok, _} = DAO.delete(Produtos, updated.id)
  end

  setup :clean_db

  @tag pedido_crud: true
  test "Pedido CRUD", context do
    {:ok, cliente} = DAO.create(%Clientes{}, Clientes, context[:cliente])
    {:ok, prod} = DAO.create(%Produtos{}, Produtos, context[:produto])

    pedido =
      generate_pedido(cliente.id, [
        [id: prod.id, qtd: 2, preco: 50],
        [id: prod.id, qtd: 2, preco: 50]
      ])

    {:ok, _inserted} = DAO.create(%Pedidos{}, Pedidos, pedido)
  end
end
