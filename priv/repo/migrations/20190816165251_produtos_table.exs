defmodule PagBackend.Repo.Migrations.ProdutosTable do
  use Ecto.Migration

  def change do
    create table("produtos") do
      add :nome, :string, size: 100
      add :preco_sugerido, :integer
      timestamps([type: :utc_datetime])
    end
  end
end
