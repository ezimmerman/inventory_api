defmodule InventoryApi.InventoryAdjustmentControllerTest do
  use InventoryApi.ConnCase

  alias InventoryApi.InventoryAdjustment
  @valid_attrs %{external_transaction_id: "some content", item_id: "some content", location_id: "some content", quantity: "120.5", transaction_code: "InventoryAdjustment", uom_code: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, inventory_adjustment_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    inventory_adjustment = Repo.insert! %InventoryAdjustment{}
    conn = get conn, inventory_adjustment_path(conn, :show, inventory_adjustment)
    assert json_response(conn, 200)["data"] == %{"id" => inventory_adjustment.id,
      "external_transaction_id" => inventory_adjustment.external_transaction_id,
      "quantity" => inventory_adjustment.quantity,
      "uom_code" => inventory_adjustment.uom_code,
      "transaction_code" => inventory_adjustment.transaction_code,
      "item_id" => inventory_adjustment.item_id,
      "location_id" => inventory_adjustment.location_id}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, inventory_adjustment_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, inventory_adjustment_path(conn, :create), inventory_adjustment: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(InventoryAdjustment, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, inventory_adjustment_path(conn, :create), inventory_adjustment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    inventory_adjustment = Repo.insert! %InventoryAdjustment{}
    conn = put conn, inventory_adjustment_path(conn, :update, inventory_adjustment), inventory_adjustment: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(InventoryAdjustment, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    inventory_adjustment = Repo.insert! %InventoryAdjustment{}
    conn = put conn, inventory_adjustment_path(conn, :update, inventory_adjustment), inventory_adjustment: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    inventory_adjustment = Repo.insert! %InventoryAdjustment{}
    conn = delete conn, inventory_adjustment_path(conn, :delete, inventory_adjustment)
    assert response(conn, 204)
    refute Repo.get(InventoryAdjustment, inventory_adjustment.id)
  end
end
