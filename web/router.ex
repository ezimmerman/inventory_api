defmodule InventoryApi.Router do
  use InventoryApi.Web, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", InventoryApi do
    pipe_through :api
    resources "/inventory_adjustments", InventoryAdjustmentController, except: [:new, :edit]
    resources "/inventory_counts", InventoryCountController, only: [:index, :show]
  end
end
