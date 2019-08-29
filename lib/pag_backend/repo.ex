defmodule PagBackend.Repo do
  @moduledoc false

  use Ecto.Repo,
    otp_app: :pag_backend,
    adapter: Ecto.Adapters.Postgres

  use Scrivener, page_size: 20

  def current_time() do
    {:ok, dt} = DateTime.now("Etc/UTC")
    DateTime.truncate(dt, :second)
  end

  def date_greater_than_now(field, date) do
    case Date.diff(Date.utc_today(), date) do
      tmp when tmp > 0 -> []
      tmp when tmp < 0 -> [{field, "Invalid date"}]
    end
  end

  def get_with_ok(module, id) do
    case __MODULE__.get(module, id) do
      nil -> {:error, nil}
      v -> {:ok, v}
    end
  end
end
