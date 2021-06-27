defmodule PhxTodoAppWeb.ItemLive.ItemComponent do
  use PhxTodoAppWeb, :live_component

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div id="item-<%= @item.id %>">
      <div class="row item">
        <div clsss="column column-20">
          <%= if @item.done do %>
            <a href="#" phx-click="undo" phx-target="<%= @myself %>" class="item-check">
              <input type="checkbox" checked>
            </a>
          <% else %>
            <a href="#" phx-click="done" phx-target="<%= @myself %>" class="item-check">
              <input type="checkbox">
            </a>
          <% end %>
        </div>
        <div class="column column-80 item-body">
          <p><%= @item.title %></p>
        </div>
        <div class="column-10">
          <%= link to: "#", phx_click: "higher_priority", phx_target: @myself do %>
            <span>↑</span>
          <% end %>
          <%= link to: "#", phx_click: "lower_priority", phx_target: @myself do %>
            <span>↓</span>
          <% end %>
        </div>
        <div class="column column-20 item-tool">
          <%= live_patch to: Routes.item_index_path(@socket, :edit, @item.id) do %>
            <span>Edit</span>
          <% end %>
          <%= link to: "#", phx_click: "delete", phx_target: @myself do %>
            <span>Delete</span>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  def handle_event("done", _, socket) do
    PhxTodoApp.Todolist.update_item_status(socket.assigns.item, true)
    {:noreply, socket}
  end

  def handle_event("undo", _, socket) do
    PhxTodoApp.Todolist.update_item_status(socket.assigns.item, false)
    {:noreply, socket}
  end

  def handle_event("delete", _, socket) do
    PhxTodoApp.Todolist.delete_item(socket.assigns.item)
    {:noreply, socket}
  end

  def handle_event("higher_priority", _, socket) do
    PhxTodoApp.Todolist.higher_priority(socket.assigns.item)
    {:noreply, socket}
  end

  def handle_event("lower_priority", _, socket) do
    PhxTodoApp.Todolist.lower_priority(socket.assigns.item)
    {:noreply, socket}
  end
end
