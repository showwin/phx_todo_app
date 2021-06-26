defmodule PhxTodoAppWeb.ItemLive.ItemComponent do
  use PhxTodoAppWeb, :live_component

  @spec render(any) :: Phoenix.LiveView.Rendered.t()
  def render(assigns) do
    ~L"""
    <div id="item-<%= @item.id %>">
      <div class="row item">
        <div clsss="column column-20 item-check">
          <span>DONE: <%= @item.done %></span>
          <%= if @item.done do %>
            <a href="#" phx-click="undo" phx-target="<%= @myself %>">
              <input type="checkbox" checked>
            </a>
          <% else %>
            <a href="#" phx-click="done" phx-target="<%= @myself %>">
              <input type="checkbox">
            </a>
          <% end %>
        </div>
        <div class="column column-70 item-body">
          <p><%= @item.title %></p>
        </div>
        <div class="column column-10">
        <%= live_patch to: Routes.item_index_path(@socket, :edit, @item.id) do %>
          <span>更新</span>
        <% end %>
      </div>
      </div>
    </div>
    """
  end

  def handle_event("done", _, socket) do
    PhxTodoApp.Todolist.update_item_status(socket.assigns.item, is_done=true)
    {:noreply, socket}
  end

  def handle_event("undo", _, socket) do
    PhxTodoApp.Todolist.update_item_status(socket.assigns.item, is_done=false)
    {:noreply, socket}
  end
end
