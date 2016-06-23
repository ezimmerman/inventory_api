defmodule InventoryApi.Repo.Migrations.CreateInventoryCount do
  use Ecto.Migration

  def change do
    create table(:inventory_counts) do
      add :quantity, :decimal
      add :inventory_adjustment_id, references(:inventory_adjustments, on_delete: :nothing)

      timestamps
    end
    create index(:inventory_counts, [:inventory_adjustment_id])

  end
end
