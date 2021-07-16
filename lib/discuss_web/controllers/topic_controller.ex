defmodule DiscussWeb.TopicController do
  use DiscussWeb, :controller
  alias Discuss.Topic
  alias Discuss.Repo
  plug DiscussWeb.Plugs.RequireAuth when action in [:new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    topics = Repo.all(Topic)

    render(conn, "index.html", topics: topics)
  end


  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})
    sum = 1 + 1
    render(conn, "new.html", changeset: changeset, sum: sum)
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    changeset = conn.assigns[:user]
                |> build_assoc(:topics)
                |> Topic.changeset(topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Created")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:warning, "Topic could not be created!")
        |> render("new.html", changeset: changeset)
    end
  end

  def edit(conn, %{"id"=> id} = _params) do
    topic = Repo.get(Topic, id);
    changeset = Topic.changeset(topic)

    render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def update(conn, %{"id" => topic_id, "topic" => topic} = _params) do
    changeset = Repo.get(Topic, topic_id) |> Topic.changeset(topic)

    case Repo.update(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic Updated!")
        |> redirect(to: Routes.topic_path(conn, :index))
      {:error, changeset} ->
        conn
        |> put_flash(:warning, "Topic could not be changed!")
        |> render("edit.html", changeset: changeset, topic: topic)
    end    # render(conn, "edit.html", changeset: changeset, topic: topic)
  end

  def delete(conn, %{"id" => topic_id} = _params) do
    Repo.get!(Topic, topic_id)
    |> Repo.delete!

    conn
    |> put_flash(:info, "Topic Deleted!")
    |> redirect(to: Routes.topic_path(conn, :index))
  end
end
