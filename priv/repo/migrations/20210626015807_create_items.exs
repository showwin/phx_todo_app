defmodule PhxTodoApp.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :title, :string
      add :done, :boolean, default: false, null: false

      timestamps()
    end

  end
end
