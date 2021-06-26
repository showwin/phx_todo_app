defmodule PhxTodoAppWeb.PageController do
  use PhxTodoAppWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
