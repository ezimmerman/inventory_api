defmodule InventoryApi.Repo.Migrations.CreateInventoryAdjustment do
  use Ecto.Migration

  def change do
    create table(:inventory_adjustments) do
      add :external_transaction_id, :string
      add :quantity, :decimal
      add :uom_code, :string
      add :transaction_code, :string
      add :item_id, :string
      add :location_id, :string

      timestamps
    end

  end
end
