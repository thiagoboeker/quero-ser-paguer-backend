defmodule PagBackend.Schema.Clientes do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @fields [:nome, :cpf, :data_nascimento, :email]
  @encoding [:id, :nome, :cpf, :data_nascimento, :email]

  @derive {Poison.Encoder, only: @encoding}
  schema "clientes" do
    field(:nome, :string)
    field(:cpf, :string)
    field(:email, :string)
    field(:data_nascimento, :date)
    timestamps(type: :utc_datetime, auto_generate: {PagBackend.Repo, :current_time, []})
  end

  def changeset(changeset, params \\ %{}) do
    changeset
    |> cast(params, @fields)
    |> unique_constraint(:cpf)
    |> validate_required(@fields)
    |> validate_change(:data_nascimento, &PagBackend.Repo.date_greater_than_now/2)
    |> unique_constraint(:email)
  end
end
