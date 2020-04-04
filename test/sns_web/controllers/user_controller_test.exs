defmodule SnsWeb.UserControllerTest do
  use SnsWeb.ConnCase

  alias Sns.Users
  alias Sns.Users.User

  @create_attrs %{
    is_admin: true,
    name: "some name",
    password: "some password_hash1Q",
    phone: "some phone"
  }
  @update_attrs %{
    is_admin: false,
    name: "some updated name",
    password: "some updated password_hash1Q",
    phone: "some updated phone"
  }
  @invalid_attrs %{is_admin: nil, name: nil, password_hash: nil, phone: nil}

  def fixture(:user) do
    {:ok, user} = Users.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = Sns.Guardian.Plug.sign_in(conn, %{id: id})

      assert %{
               "id" => id,
               "is_admin" => true,
               "name" => "some name",
               "phone" => "some phone"
             } = json_response(conn, 200)["data"]

      assert Comeonin.Bcrypt.checkpw(
               "some password_hash1Q",
               json_response(conn, 200)["data"]["password_hash"]
             )
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "is_admin" => false,
               "name" => "some updated name",
               "phone" => "some updated phone"
             } = json_response(conn, 200)["data"]

      assert Comeonin.Bcrypt.checkpw(
               "some updated password_hash1Q",
               json_response(conn, 200)["data"]["password_hash"]
             )
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
