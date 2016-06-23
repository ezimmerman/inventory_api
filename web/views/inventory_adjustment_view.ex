defmodule InventoryApi.InventoryAdjustmentView do
  use InventoryApi.Web, :view

  def render("index.json", %{inventory_adjustments: inventory_adjustments}) do
    %{data: render_many(inventory_adjustments, InventoryApi.InventoryAdjustmentView, "inventory_adjustment.json")}
  end

  def render("show.json", %{inventory_adjustment: inventory_adjustment}) do
    %{data: render_one(inventory_adjustment, InventoryApi.InventoryAdjustmentView, "inventory_adjustment.json")}
  end

  def render("inventory_adjustment.json", %{inventory_adjustment: inventory_adjustment}) do
    %{id: inventory_adjustment.id,
      external_transaction_id: inventory_adjustment.external_transaction_id,
      quantity: inventory_adjustment.quantity,
      uom_code: inventory_adjustment.uom_code,
      transaction_code: inventory_adjustment.transaction_code,
      item_id: inventory_adjustment.item_id,
      location_id: inventory_adjustment.location_id}
  end
end
