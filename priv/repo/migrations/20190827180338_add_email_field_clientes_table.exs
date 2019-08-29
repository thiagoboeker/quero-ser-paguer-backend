defmodule PagBackend.Repo.Migrations.AddEmailFieldClientesTable do
  use Ecto.Migration

  def change do
    alter table("clientes") do
      add :email, :string, size: 50
    end

    create unique_index(:clientes, [:email])
  end
end
