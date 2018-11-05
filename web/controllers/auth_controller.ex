defmodule Discuss.AuthController do
  use Discuss.Web, :controller
  plug Ueberauth

  alias Discuss.User
  alias Discuss.Repo

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, params) do
    IO.inspect(params)
    user = %{token: auth.credentials.token, email: auth.info.email, provider: "github"}

    login(conn, user)
  end

  def signout(conn, _params) do
    conn
    |> configure_session(drop: true)
    |> redirect(to: topic_path(conn, :index))
  end

  defp login(conn, user) do
    case insert_or_update(user) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Welcome back!")
        |> put_session(:user_id, user.id)
        |> redirect(to: topic_path(conn, :index))
      {:error, _reason} ->
        conn
        |> put_flash(:error, "Error in login")
        |> redirect(to: topic_path(conn, :index))
    end
  end

  defp insert_or_update(user_attrs) do
    case Repo.get_by(User, email: user_attrs.email) do
      nil -> Repo.insert(User.changeset(%User{}, user_attrs))
      existing_user -> {:ok, existing_user}
    end
  end
end