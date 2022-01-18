defmodule KwtoolWeb.CheckEmptyBodyParamsPlugTest do
  use KwtoolWeb.ConnCase, async: true

  alias KwtoolWeb.CheckEmptyBodyParamsPlug

  describe "init/1" do
    test "returns given options" do
      assert CheckEmptyBodyParamsPlug.init([]) == []
    end
  end

  describe "call/2" do
    test "halts the conn and returns 400 status if body params are empty", %{conn: conn} do
      conn =
        conn
        |> Map.put(:body_params, %{})
        |> CheckEmptyBodyParamsPlug.call([])

      assert conn.halted == true

      assert json_response(conn, 400) == %{
               "errors" => [
                 %{
                   "code" => "bad_request",
                   "detail" => %{},
                   "message" => "Missing body params"
                 }
               ]
             }
    end

    test "returns conn if body params are NOT empty", %{conn: conn} do
      conn =
        conn
        |> Map.put(:body_params, %{name: "John Doe"})
        |> CheckEmptyBodyParamsPlug.call([])

      assert conn.halted == false
    end
  end
end
