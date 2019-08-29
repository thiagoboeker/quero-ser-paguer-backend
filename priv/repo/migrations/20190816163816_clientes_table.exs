defmodule PagBackend.Repo.Migrations.ClientesTable do
  use Ecto.Migration

  def change do
    create table("clientes") do
      add :nome, :string, size: 100
      add :cpf, :string, size: 11
      add :data_nascimento, :"DATE"
      timestamps([type: :utc_datetime])
    end
    
    create unique_index(:clientes, [:cpf])
  end
end
