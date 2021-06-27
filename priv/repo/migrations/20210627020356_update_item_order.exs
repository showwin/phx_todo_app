defmodule PhxTodoApp.Repo.Migrations.UpdateItemOrder do
  use Ecto.Migration

  def change do
    alter table(:items) do
      modify :order, :float
    end
  end
end
