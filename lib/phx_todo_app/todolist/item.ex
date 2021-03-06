defmodule PhxTodoApp.Todolist.Item do
  use Ecto.Schema
  import Ecto.Changeset

  schema "items" do
    field :done, :boolean, default: false
    field :title, :string
    field :order, :float, default: 1.0

    timestamps()
  end

  @doc false
  def changeset(item, attrs) do
    item
    |> cast(attrs, [:title, :order])
    |> validate_required([:title, :order])
    |> validate_length(:title, min: 2, max: 250)
  end
end
