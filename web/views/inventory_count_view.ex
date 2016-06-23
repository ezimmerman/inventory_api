defmodule InventoryApi.InventoryCountView do
  use InventoryApi.Web, :view

  def render("index.json", %{inventory_counts: inventory_counts}) do
    %{data: render_many(inventory_counts, InventoryApi.InventoryCountView, "inventory_count.json")}
  end

  def render("show.json", %{inventory_count: inventory_count}) do
    %{data: render_one(inventory_count, InventoryApi.InventoryCountView, "inventory_count.json")}
  end

  def render("inventory_count.json", %{inventory_count: inventory_count}) do
    %{id: inventory_count.id,
      inventory_adjustment_id: inventory_count.inventory_adjustment_id,
      quantity: inventory_count.quantity}
  end
end
