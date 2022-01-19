defmodule KwtoolWeb.Api.V1.SessionControllerTest do
  use KwtoolWeb.ConnCase, async: true

  describe "POST create/2" do
    test "given valid user credentials, returns access token", %{conn: conn} do
      insert(:user, email: "test@gmail.com")

      conn =
        post(conn, Routes.api_session_path(conn, :create), %{
          email: "test@gmail.com",
          password: "123456"
        })

      assert %{
               "data" => %{
                 "attributes" => %{
                   "email" => "test@gmail.com",
                   "jwt" => _
                 },
                 "id" => _,
                 "relationships" => %{},
                 "type" => "logins"
               },
               "included" => []
             } = json_response(conn, 200)
    end

    test "given invalid user credentials, returns error", %{conn: conn} do
      insert(:user, email: "test@gmail.com")

      conn =
        post(conn, Routes.api_session_path(conn, :create), %{
          email: "test@gmail.com",
          password: ""
        })

      assert %{
               "errors" => [
                 %{
                   "code" => "unauthorized",
                   "detail" => %{},
                   "message" => "User could not be authenticated"
                 }
               ]
             } = json_response(conn, 401)
    end
  end
end
