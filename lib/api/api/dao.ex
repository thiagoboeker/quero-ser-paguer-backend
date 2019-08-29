defmodule PagBackend.Api.DAO do
  @moduledoc """
  Database wrapper para funcoes basicas de banco de dados
  """

  alias PagBackend.Repo

  @doc """
  Retorna todos as rows do schema passado
  """
  def all(schema, params) do
    Repo.all(schema)
    |> Scrivener.paginate(params)
  end

  @doc """
  Atraves do schema e de um id, retorna a row no formato `{:ok, row}`
  """
  def show(schema, id) do
    case Repo.get_with_ok(schema, id) do
      nil -> {:exception, %{error: "NOT FOUND"}}
      v -> v
    end
  end

  @doc """
  Cria um registro no banco de dados.
  """
  def create(schema, mod, params \\ %{}) do
    mod.changeset(schema, params)
    |> Repo.insert()
  end

  @doc """
  Atualiza um registro do banco de dados.
  """
  def update({:ok, changeset}, schema, params) do
    schema.changeset(changeset, params)
    |> Repo.update()
  end

  @doc false
  def update({:exception, _} = op, _, _), do: op

  @doc false
  def update({:error, _} = op, _, _), do: op

  @doc false
  def update(schema, id, params) do
    with {:ok, value} <- Repo.get_with_ok(schema, id),
         changeset <- schema.changeset(value, params) do
      Repo.update(changeset)
    else
      error -> error
    end
  end

  @doc """
  Deleta um registro da tabela do schema.
  """
  def delete(schema, id) do
    with {:ok, value} <- Repo.get_with_ok(schema, id) do
      Repo.delete(value)
    else
      error -> error
    end
  end

  @doc false
  def delete(schema), do: Repo.delete(schema)

  @doc """
  Carrega relationships de chaves estrangeiras do schema
  """
  def preload(op, field) do
    with {:ok, changeset} <- op, v when not is_nil(v) <- Repo.preload(changeset, field) do
      {:ok, v}
    else
      _ -> {:exception, %{error: "NOT FOUND"}}
    end
  end
end
