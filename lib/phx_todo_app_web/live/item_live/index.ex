defmodule PhxTodoAppWeb.ItemLive.Index do
  use PhxTodoAppWeb, :live_view

  alias PhxTodoApp.Todolist
  alias PhxTodoApp.Todolist.Item

  @impl true
  def mount(_params, _session, socket) do
    if connected?(socket), do: Todolist.subscribe()
    {:ok, assign(socket, :items, list_items())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Item")
    |> assign(:item, Todolist.get_item!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Item")
    |> assign(:item, %Item{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Items")
    |> assign(:item, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    item = Todolist.get_item!(id)
    {:ok, _} = Todolist.delete_item(item)

    {:noreply, assign(socket, :items, list_items())}
  end

  @impl true
  def handle_info({:item_created, item}, socket) do
    {:noreply, update(socket, :items, fn items -> [items | item] end)}
  end
  def handle_info({:item_updated, item}, socket) do
    {:noreply, update(socket, :items, fn items -> [items | item] end)}
  end
  def handle_info({:item_deleted, item}, socket) do
    {:noreply, update(socket, :items, fn items -> items -- item end)}
  end

  defp list_items do
    Todolist.list_items()
  end
end
