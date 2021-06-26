defmodule PhxTodoApp.Repo do
  use Ecto.Repo,
    otp_app: :phx_todo_app,
    adapter: Ecto.Adapters.Postgres
end
