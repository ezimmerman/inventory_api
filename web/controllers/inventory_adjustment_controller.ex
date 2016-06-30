require IEx;
defmodule InventoryApi.InventoryAdjustmentController do
  use InventoryApi.Web, :controller
  import Ecto.Query, only: [from: 2]

  alias InventoryApi.InventoryAdjustment
  alias InventoryApi.InventoryCount

  plug :scrub_params, "inventory_adjustment" when action in [:create, :update]

  def index(conn, _params) do
    inventory_adjustments = Repo.all(InventoryAdjustment)
    render(conn, "index.json", inventory_adjustments: inventory_adjustments)
  end

  def create(conn, %{"inventory_adjustment" => inventory_adjustment_params}) do

    case inventory_adjustment_params["transaction_code"] do
      "InventoryAdjustment" ->
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
      "InventoryCount" ->
        initial_qty = Decimal.new(inventory_adjustment_params["quantity"])
        adjust_quantity = Decimal.sub(Decimal.new(initial_qty), calculate_stock_on_hand(inventory_adjustment_params["item_id"], inventory_adjustment_params["location_id"]))
          case insert_adjustment_count(initial_qty, adjust_quantity, inventory_adjustment_params) do
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

  def calculate_stock_on_hand(item_id, location_id) do
    latest_stock_count_adjustment = Repo.one(from a in InventoryAdjustment,
    order_by: [desc: a.inserted_at],
    where: a.item_id == ^item_id and a.location_id == ^location_id and a.transaction_code == "InventoryCount",
    limit: 1)
    if is_nil(latest_stock_count_adjustment) do
      Repo.one(from a in InventoryAdjustment,
      select: sum(a.quantity),
      where: a.item_id == ^item_id and a.location_id == ^location_id)
    else
      latest_stock_count = Repo.get_by(InventoryCount, inventory_adjustment_id: latest_stock_count_adjustment.id)
      Decimal.add(latest_stock_count.quantity,  get_total_adjustments(item_id, location_id, latest_stock_count))
    end
  end

  def insert_adjustment_count(count_qty, adjust_qty, params) do
      adjustment_changeset = InventoryAdjustment.changeset(%InventoryAdjustment{}, %{params | "quantity" => adjust_qty})
    Repo.transaction fn ->
      adjustment = Repo.insert!(adjustment_changeset)
      count = Ecto.build_assoc(adjustment, :inventory_count, quantity: count_qty)
      Repo.insert!(count)
    end
  end

  def get_total_adjustments(item_id, location_id, latest_stock_count) do
     total_adjustments = Repo.one(from a in InventoryAdjustment,
     select: sum(a.quantity),
     where: a.item_id == ^item_id and a.location_id == ^location_id and a.inserted_at > ^latest_stock_count.inserted_at)
     if is_nil(total_adjustments) do
       Decimal.new 0
     else
       total_adjustments
     end
  end
end
