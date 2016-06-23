defmodule InventoryApi.InventoryCountControllerTest do
  use InventoryApi.ConnCase

  alias InventoryApi.InventoryCount
  @valid_attrs %{quantity: "120.5"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, inventory_count_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    inventory_count = Repo.insert! %InventoryCount{}
    conn = get conn, inventory_count_path(conn, :show, inventory_count)
    assert json_response(conn, 200)["data"] == %{"id" => inventory_count.id,
      "inventory_adjustment_id" => inventory_count.inventory_adjustment_id,
      "quantity" => inventory_count.quantity}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, inventory_count_path(conn, :show, -1)
    end
  end
end
