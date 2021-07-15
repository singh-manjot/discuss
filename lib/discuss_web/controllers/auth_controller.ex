defmodule DiscussWeb.AuthController do
  use DiscussWeb, :controller
  plug Ueberauth
  alias Discuss.User
  alias Discuss.Repo

  def request(conn, params) do
    # IO.inspect(conn)
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    # IO.puts "++++++++++++++++++++++++++++++++"
    # IO.inspect(conn.assigns)
    # IO.inspect(conn.params)
    # IO.puts "++++++++++++++++++++++++++++++++"

    %{credentials: %{token: token}} = auth
    %{info: %{email: email}} = auth

    user_params = %{token: token, email: email, provider: "github"}
    changeset = User.changeset(%User{}, user_params)

    signin(conn, changeset)
  end

  defp signin(conn, changeset) do
    case insert_or_update_user(changeset) do
      {:ok, user} ->
        conn
        |> put_flash(:info, 'Welcome back!')
        |> put_session(:user_id, user.id)
        |> redirect(to: Routes.topic_path(conn, :index))

      {:error, _reason} ->
        conn
        |> put_flash(:error, 'Error signing in.')
        |> redirect(to: Routes.topic_path(conn, :index))
    end

  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> IO.inspect()
    |> redirect(to: Routes.topic_path(conn,:index))

  end

  defp insert_or_update_user(changeset) do
    case Repo.get_by(User, email: changeset.changes.email) do
      nil ->
        Repo.insert(changeset)
      user ->
        {:ok, user}
    end
  end
end
