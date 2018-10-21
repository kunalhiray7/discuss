defmodule Discuss.TopicController do
  use Discuss.Web, :controller
  alias Discuss.Topic

  def new(conn, _params) do
    changeset = Topic.changeset(%Topic{}, %{})

    render conn, "new.html", changeset: changeset
  end

  def create(conn, %{"topic" => topic}) do
    changeset = Topic.changeset(%Topic{}, topic)

    case Repo.insert(changeset) do
      {:ok, _topic} ->
        conn
        |> put_flash(:info, "Topic is created")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> render conn, "new.html", changeset: changeset
    end
  end

  def index(conn, _params) do
    topics = Repo.all(Topic)

    render conn, "index.html", topics: topics
  end

  def edit(conn, %{"id" => topic_id}) do
    existing_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(existing_topic)

    render conn, "edit.html", changeset: changeset, topic: existing_topic
  end

  def update(conn, %{"id" => topic_id, "topic" => topic}) do
    existing_topic = Repo.get(Topic, topic_id)
    changeset = Topic.changeset(existing_topic, topic)

    case Repo.update(changeset) do
      {:ok, topic} ->
        conn
        |> put_flash(:info, "Topic is updated")
        |> redirect(to: topic_path(conn, :index))
      {:error, changeset} -> render conn, "edit.html", changeset: changeset, topic: existing_topic
    end
  end

  def delete(conn, %{"id" => topic_id}) do
    Repo.get!(Topic, topic_id)
    |> Repo.delete!

    conn
    |> put_flash(:info, "Topic is deleted")
    |> redirect(to: topic_path(conn, :index))
  end
end