defmodule PagBackend.Repo.Migrations.PedidosTable do
  use Ecto.Migration

  def change do
    create table("pedidos") do
      add :id_cliente, references(:clientes)
      add :valor, :"DECIMAL(10,2)"
      timestamps([type: :utc_datetime])
    end
  end
end
