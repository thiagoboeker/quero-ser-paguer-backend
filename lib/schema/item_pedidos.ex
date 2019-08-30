defmodule PagBackend.Schema.ItemPedidos do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @fields [:id_produto, :id_pedido, :quantidade, :preco]
  @encoding [:id, :id_produto, :id_pedido, :quantidade, :preco, :inserted_at, :updated_at]

  @derive {Poison.Encoder, only: @encoding}
  schema "item_pedidos" do
    belongs_to(:produto, PagBackend.Schema.Produtos, foreign_key: :id_produto)
    belongs_to(:pedido, PagBackend.Schema.Pedidos, foreign_key: :id_pedido)
    field(:quantidade, :integer)
    field(:preco, :integer)
    timestamps(type: :utc_datetime, auto_generate: {PagBackend.Repo, :current_time, []})
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, @fields)
    |> validate_required([:id_produto, :quantidade, :preco])
    |> validate_number(:quantidade, greater_than_or_equal_to: 0)
    |> validate_number(:preco, greater_than_or_equal_to: 0)
  end
end
