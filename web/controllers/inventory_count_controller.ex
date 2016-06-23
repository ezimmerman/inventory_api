defmodule InventoryApi.InventoryCountController do
  use InventoryApi.Web, :controller

  alias InventoryApi.InventoryCount

  plug :scrub_params, "inventory_count" when action in [:create, :update]

  def index(conn, _params) do
    inventory_counts = Repo.all(InventoryCount)
    render(conn, "index.json", inventory_counts: inventory_counts)
  end

  def create(conn, %{"inventory_count" => inventory_count_params}) do
    changeset = InventoryCount.changeset(%InventoryCount{}, inventory_count_params)

    case Repo.insert(changeset) do
      {:ok, inventory_count} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", inventory_count_path(conn, :show, inventory_count))
        |> render("show.json", inventory_count: inventory_count)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(InventoryApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    inventory_count = Repo.get!(InventoryCount, id)
    render(conn, "show.json", inventory_count: inventory_count)
  end

  def update(conn, %{"id" => id, "inventory_count" => inventory_count_params}) do
    inventory_count = Repo.get!(InventoryCount, id)
    changeset = InventoryCount.changeset(inventory_count, inventory_count_params)

    case Repo.update(changeset) do
      {:ok, inventory_count} ->
        render(conn, "show.json", inventory_count: inventory_count)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(InventoryApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    inventory_count = Repo.get!(InventoryCount, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(inventory_count)

    send_resp(conn, :no_content, "")
  end
end
