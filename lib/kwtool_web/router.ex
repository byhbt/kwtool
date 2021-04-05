defmodule KwtoolWeb.Router do
  use KwtoolWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # coveralls-ignore-start
  pipeline :api do
    plug :accepts, ["json"]
  end

  # coveralls-ignore-stop

  scope "/", KwtoolWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/sign_up", AuthController, :show
    post "/sign_up", AuthController, :create

    get "/sign_in", AuthController, :new
    post "/sign_in", AuthController, :update
  end

  # Other scopes may use custom stacks.
  # scope "/api", KwtoolWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      # coveralls-ignore-start
      live_dashboard "/dashboard", metrics: KwtoolWeb.Telemetry
      # coveralls-ignore-stop
    end
  end
end
