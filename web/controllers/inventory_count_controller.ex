defmodule InventoryApi.InventoryCountController do
  use InventoryApi.Web, :controller

  alias InventoryApi.InventoryCount

  plug :scrub_params, "inventory_count" when action in [:create, :update]

  def index(conn, _params) do
    inventory_counts = Repo.all(InventoryCount)
    render(conn, "index.json", inventory_counts: inventory_counts)
  end

  def show(conn, %{"id" => id}) do
    inventory_count = Repo.get!(InventoryCount, id)
    render(conn, "show.json", inventory_count: inventory_count)
  end
end
