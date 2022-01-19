defmodule KwtoolWeb.Api.V1.ErrorHandlerTest do
  use KwtoolWeb.ConnCase, async: true

  alias KwtoolWeb.Api.V1.ErrorHandler

  describe "auth_error/2" do
    test "renders 401 error page", %{conn: conn} do
      conn = ErrorHandler.auth_error(conn, {401, ""}, "")

      assert %{
               "errors" => [
                 %{
                   "code" => "unauthorized",
                   "detail" => %{},
                   "message" => "Unauthorized"
                 }
               ]
             } = json_response(conn, 401)

      assert conn.halted
    end
  end
end
