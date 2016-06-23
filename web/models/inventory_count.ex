defmodule InventoryApi.InventoryCount do
  use InventoryApi.Web, :model

  schema "inventory_counts" do
    field :quantity, :decimal
    belongs_to :inventory_adjustment, InventoryApi.InventoryAdjustment

    timestamps
  end

  @required_fields ~w(quantity)
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
