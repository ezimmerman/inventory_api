defmodule InventoryApi.InventoryCountTest do
  use InventoryApi.ModelCase

  alias InventoryApi.InventoryCount

  @valid_attrs %{quantity: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = InventoryCount.changeset(%InventoryCount{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = InventoryCount.changeset(%InventoryCount{}, @invalid_attrs)
    refute changeset.valid?
  end
end
