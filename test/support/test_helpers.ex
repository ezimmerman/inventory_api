defmodule InventoryApi.TestHelpers do
  alias InventoryApi.Repo

  def insert_adjustment(attrs) do
    Repo.insert!(attrs)
  end

  def insert_adjustment_count(count, adjustment) do
    adjustment = Repo.insert!(adjustment)
    count
    |> Ecto.build_assoc(adjustment, :inventory_count)
    |> Repo.insert!()
  end
end
