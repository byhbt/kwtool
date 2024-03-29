defmodule KwtoolWeb.CheckEmptyBodyParamsPlugTest do
  use KwtoolWeb.ConnCase, async: true

  alias KwtoolWeb.CheckEmptyBodyParamsPlug

  describe "init/1" do
    test "returns given options" do
      assert CheckEmptyBodyParamsPlug.init([]) == []
    end
  end

  describe "call/2" do
    test "given the request body param is empty, halts the conn and returns 400 status", %{
      conn: conn
    } do
      conn =
        conn
        |> Map.put(:body_params, %{})
        |> Map.put(:method, "POST")
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

    test "given the GET request with empty body param, does NOT halt the conn", %{
      conn: conn
    } do
      conn =
        conn
        |> Map.put(:body_params, %{})
        |> Map.put(:method, "GET")
        |> CheckEmptyBodyParamsPlug.call([])

      assert conn.halted == false
    end

    test "given the DELETE request with empty body param, does NOT halt the conn", %{
      conn: conn
    } do
      conn =
        conn
        |> Map.put(:body_params, %{})
        |> Map.put(:method, "DELETE")
        |> CheckEmptyBodyParamsPlug.call([])

      assert conn.halted == false
    end

    test "given the request body params are NOT empty, returns the conn", %{conn: conn} do
      conn =
        conn
        |> Map.put(:body_params, %{name: "John Doe"})
        |> Map.put(:method, "POST")
        |> CheckEmptyBodyParamsPlug.call([])

      assert conn.halted == false
    end
  end
end
