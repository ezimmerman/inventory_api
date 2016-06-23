ExUnit.start

Mix.Task.run "ecto.create", ~w(-r InventoryApi.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r InventoryApi.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(InventoryApi.Repo)

