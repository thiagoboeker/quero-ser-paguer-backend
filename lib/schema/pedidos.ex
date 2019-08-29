defmodule PagBackend.Schema.Pedidos do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  @fields [:id_cliente]
  @encoding [:id, :id_cliente, :valor, :items, :inserted_at, :updated_at]

  @derive {Poison.Encoder, only: @encoding}
  schema "pedidos" do
    belongs_to(:cliente, PagBackend.Schema.Clientes, foreign_key: :id_cliente)
    has_many(:items, PagBackend.Schema.ItemPedidos, foreign_key: :id_pedido)
    field(:valor, :float)
    timestamps(type: :utc_datetime, auto_generate: {PagBackend.Repo, :current_time, []})
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> cast_assoc(:items)
    |> validate_length(:items, min: 1)
    |> prepare_changes(&calcula_valor/1)
  end

  defp calcula_valor(changeset) do
    valor =
      changeset
      |> get_change(:items)
      |> Enum.reduce(0, fn item, acc -> acc + item.changes.quantidade * item.changes.preco end)

    put_change(changeset, :valor, valor)
  end
end
