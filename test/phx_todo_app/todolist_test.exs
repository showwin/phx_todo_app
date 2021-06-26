defmodule PhxTodoApp.TodolistTest do
  use PhxTodoApp.DataCase

  alias PhxTodoApp.Todolist

  describe "items" do
    alias PhxTodoApp.Todolist.Item

    @valid_attrs %{done: true, title: "some title"}
    @update_attrs %{done: false, title: "some updated title"}
    @invalid_attrs %{done: nil, title: nil}

    def item_fixture(attrs \\ %{}) do
      {:ok, item} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Todolist.create_item()

      item
    end

    test "list_items/0 returns all items" do
      item = item_fixture()
      assert Todolist.list_items() == [item]
    end

    test "get_item!/1 returns the item with given id" do
      item = item_fixture()
      assert Todolist.get_item!(item.id) == item
    end

    test "create_item/1 with valid data creates a item" do
      assert {:ok, %Item{} = item} = Todolist.create_item(@valid_attrs)
      assert item.done == true
      assert item.title == "some title"
    end

    test "create_item/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todolist.create_item(@invalid_attrs)
    end

    test "update_item/2 with valid data updates the item" do
      item = item_fixture()
      assert {:ok, %Item{} = item} = Todolist.update_item(item, @update_attrs)
      assert item.done == false
      assert item.title == "some updated title"
    end

    test "update_item/2 with invalid data returns error changeset" do
      item = item_fixture()
      assert {:error, %Ecto.Changeset{}} = Todolist.update_item(item, @invalid_attrs)
      assert item == Todolist.get_item!(item.id)
    end

    test "delete_item/1 deletes the item" do
      item = item_fixture()
      assert {:ok, %Item{}} = Todolist.delete_item(item)
      assert_raise Ecto.NoResultsError, fn -> Todolist.get_item!(item.id) end
    end

    test "change_item/1 returns a item changeset" do
      item = item_fixture()
      assert %Ecto.Changeset{} = Todolist.change_item(item)
    end
  end
end
