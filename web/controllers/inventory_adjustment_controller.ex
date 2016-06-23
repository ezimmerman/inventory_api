defmodule InventoryApi.InventoryAdjustmentController do
  use InventoryApi.Web, :controller

  alias InventoryApi.InventoryAdjustment

  plug :scrub_params, "inventory_adjustment" when action in [:create, :update]

  def index(conn, _params) do
    inventory_adjustments = Repo.all(InventoryAdjustment)
    render(conn, "index.json", inventory_adjustments: inventory_adjustments)
  end

  def create(conn, %{"inventory_adjustment" => inventory_adjustment_params}) do
    changeset = InventoryAdjustment.changeset(%InventoryAdjustment{}, inventory_adjustment_params)

    case Repo.insert(changeset) do
      {:ok, inventory_adjustment} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", inventory_adjustment_path(conn, :show, inventory_adjustment))
        |> render("show.json", inventory_adjustment: inventory_adjustment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(InventoryApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    inventory_adjustment = Repo.get!(InventoryAdjustment, id)
    render(conn, "show.json", inventory_adjustment: inventory_adjustment)
  end

  def update(conn, %{"id" => id, "inventory_adjustment" => inventory_adjustment_params}) do
    inventory_adjustment = Repo.get!(InventoryAdjustment, id)
    changeset = InventoryAdjustment.changeset(inventory_adjustment, inventory_adjustment_params)

    case Repo.update(changeset) do
      {:ok, inventory_adjustment} ->
        render(conn, "show.json", inventory_adjustment: inventory_adjustment)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(InventoryApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    inventory_adjustment = Repo.get!(InventoryAdjustment, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(inventory_adjustment)

    send_resp(conn, :no_content, "")
  end
end
