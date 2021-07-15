defmodule DiscussWeb.Plugs.SetUser do
  import Plug.Conn
  import Phoenix.Controller

  alias Discuss.Repo
  alias Discuss.User

  # Runs once
  def init(_params) do
  end

  # params here is the returned value from init function
  def call(conn, _params) do
    user_id = get_session(conn, :user_id)

    cond do
      user = user_id && Repo.get(User, user_id) ->
        # conn.assigns.user -> User struct
        assign(conn, :user, user)

      true ->
        assign(conn, :user, nil)
    end
  end
end
