defmodule PagBackend.Repo.Migrations.ItemsPedidosTable do
  use Ecto.Migration

  def change do
    create table("item_pedidos") do
      add :id_pedido, references(:pedidos)
      add :id_produto, references(:produtos)
      add :quantidade, :integer
      add :preco, :integer
      timestamps([type: :utc_datetime])
    end
  end
end
