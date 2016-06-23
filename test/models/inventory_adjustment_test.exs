defmodule InventoryApi.InventoryAdjustmentTest do
  use InventoryApi.ModelCase

  alias InventoryApi.InventoryAdjustment

  @valid_attrs %{external_transaction_id: "some content", item_id: "some content", location_id: "some content", quantity: "120.5", transaction_code: "some content", uom_code: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = InventoryAdjustment.changeset(%InventoryAdjustment{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = InventoryAdjustment.changeset(%InventoryAdjustment{}, @invalid_attrs)
    refute changeset.valid?
  end
end
