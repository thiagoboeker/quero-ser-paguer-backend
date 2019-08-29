defmodule PagBackend.Schema.Produtos do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset
  @fields [:nome, :preco_sugerido]
  @encoding [:id, :nome, :preco_sugerido, :inserted_at, :updated_at]

  @derive {Poison.Encoder, only: @encoding}
  schema "produtos" do
    field(:nome, :string)
    field(:preco_sugerido, :decimal)
    timestamps(type: :utc_datetime, auto_generate: {PagBackend.Repo, :current_time, []})
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, @fields)
    |> validate_required(@fields)
    |> validate_number(:preco_sugerido, greater_than_or_equal_to: 0)
  end
end
