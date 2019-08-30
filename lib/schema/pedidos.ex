defmodule PagBackend.Schema.Pedidos do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  alias PagBackend.Schema.ItemPedidos

  @fields [:id_cliente]
  @encoding [:id, :id_cliente, :valor, :items, :inserted_at, :updated_at]

  @derive {Poison.Encoder, only: @encoding}
  schema "pedidos" do
    belongs_to(:cliente, PagBackend.Schema.Clientes, foreign_key: :id_cliente)
    has_many(:items, PagBackend.Schema.ItemPedidos, foreign_key: :id_pedido)
    field(:valor, :integer)
    timestamps(type: :utc_datetime, auto_generate: {PagBackend.Repo, :current_time, []})
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> cast_assoc(:items)
    |> validate_length(:items, min: 1)
  end

  def calcula_valor({:ok, changeset}, params) do
    valor = Enum.map(params["items"], &create_item/1) |> Enum.reduce(0, &sum_valor/2)
    {:ok, %{changeset | valor: valor}}
  end

  def calcula_valor(changeset, params) do
    {:ok, updated} = calcula_valor({:ok, changeset}, params)
    updated
  end

  defp create_item(item), do: ItemPedidos.changeset(%ItemPedidos{}, item)

  defp sum_valor(v, acc), do: acc + v.changes.preco * v.changes.quantidade
end
