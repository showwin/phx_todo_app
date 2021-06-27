defmodule PhxTodoApp.Repo.Migrations.AddOrderToItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :order, :integer
    end
  end
end
