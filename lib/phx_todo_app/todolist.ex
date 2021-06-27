defmodule PhxTodoApp.Todolist do
  @moduledoc """
  The Todolist context.
  """

  import Ecto.Query, warn: false
  alias PhxTodoApp.Repo

  alias PhxTodoApp.Todolist.Item

  @doc """
  Returns the list of items.

  ## Examples

      iex> list_items()
      [%Item{}, ...]

  """
  def list_items do
    Repo.all(from i in Item, order_by: [i.order, asc: i.inserted_at])
  end

  @doc """
  Gets a single item.

  Raises `Ecto.NoResultsError` if the Item does not exist.

  ## Examples

      iex> get_item!(123)
      %Item{}

      iex> get_item!(456)
      ** (Ecto.NoResultsError)

  """
  def get_item!(id), do: Repo.get!(Item, id)

  @doc """
  Creates a item.

  ## Examples

      iex> create_item(%{field: value})
      {:ok, %Item{}}

      iex> create_item(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_item(attrs \\ %{}) do
    [%{latest_order: latest_order}] = Repo.all(from(i in Item, select: %{latest_order: max(i.order)}))
    attrs = Map.put(attrs, "order", latest_order + 1)

    %Item{}
    |> Item.changeset(attrs)
    |> Repo.insert()
    |> broadcast(:item_created)
  end

  @doc """
  Updates a item.

  ## Examples

      iex> update_item(item, %{field: new_value})
      {:ok, %Item{}}

      iex> update_item(item, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_item(%Item{} = item, attrs) do
    item
    |> Item.changeset(attrs)
    |> Repo.update()
    |> broadcast(:item_created)
  end

  @doc """
  set item as done or not done

    ## Examples

      iex> update_item_status(item)
      {:ok, %Item{}}

      iex> update_item_status(item)
      {:error, %Ecto.Changeset{}}

  """
  def update_item_status(%Item{id: id}, is_done) do
    {1, [item]} = from(i in Item, where: i.id == ^id, select: i)
    |> Repo.update_all(set: [done: is_done])

    broadcast({:ok, item}, :item_updated)
  end

  @doc """
  set a higher priotiry to the item

    ## Examples

      iex> higher_priority(item)
      {:ok, %Item{}}

      iex> higher_priority(item)
      {:error, %Ecto.Changeset{}}

  """
  def higher_priority(%Item{} = item) do
    higher_items = Repo.all(from(i in Item, where: i.order < ^item.order, select: i, order_by: [desc: i.order], limit: 2))
    order = case length(higher_items) do
      0 -> item.order
      1 -> Enum.at(higher_items, 0).order / 2
      2 -> (Enum.at(higher_items, 0).order + Enum.at(higher_items, 1).order) / 2
    end

    update_item_order(item, order)
  end

  @doc """
  set a lower priotiry to the item

    ## Examples

      iex> lower_priority(item)
      {:ok, %Item{}}

      iex> lower_priority(item)
      {:error, %Ecto.Changeset{}}

  """
  def lower_priority(%Item{} = item) do
    lower_items = Repo.all(from(i in Item, where: i.order > ^item.order, select: i, order_by: [asc: i.order], limit: 2))
    order = case length(lower_items) do
      0 -> item.order
      1 -> Enum.at(lower_items, 0).order * 2
      2 -> (Enum.at(lower_items, 0).order + Enum.at(lower_items, 1).order) / 2
    end

    update_item_order(item, order)
  end

  @doc """
  set item order

    ## Examples

      iex> update_item_status(item)
      {:ok, %Item{}}

      iex> update_item_status(item)
      {:error, %Ecto.Changeset{}}

  """
  defp update_item_order(%Item{id: id}, order) do
    {1, [item]} = from(i in Item, where: i.id == ^id, select: i)
    |> Repo.update_all(set: [order: order])

    broadcast({:ok, item}, :item_updated)
  end

  @doc """
  Deletes a item.

  ## Examples

      iex> delete_item(item)
      {:ok, %Item{}}

      iex> delete_item(item)
      {:error, %Ecto.Changeset{}}

  """
  def delete_item(%Item{} = item) do
    Repo.delete(item)

    broadcast({:ok, item}, :item_deleted)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking item changes.

  ## Examples

      iex> change_item(item)
      %Ecto.Changeset{data: %Item{}}

  """
  def change_item(%Item{} = item, attrs \\ %{}) do
    Item.changeset(item, attrs)
  end

  def subscribe do
    Phoenix.PubSub.subscribe(PhxTodoApp.PubSub, "item")
  end

  defp broadcast({:error, _reason} = error, _event), do: error
  defp broadcast({:ok, item}, event) do
    Phoenix.PubSub.broadcast(PhxTodoApp.PubSub, "item", {event, item})
    {:ok, item}
  end
end
