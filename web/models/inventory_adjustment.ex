defmodule InventoryApi.InventoryAdjustment do
  use InventoryApi.Web, :model

  schema "inventory_adjustments" do
    field :external_transaction_id, :string
    field :quantity, :decimal
    field :uom_code, :string
    field :transaction_code, :string
    field :item_id, :string
    field :location_id, :string

    has_one :inventory_count, InventoryApi.InventoryCount

    timestamps
  end

  @required_fields ~w(external_transaction_id quantity uom_code transaction_code item_id location_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
