defmodule KwtoolWeb.Router do
  use KwtoolWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  # Our pipeline implements "maybe" authenticated. We'll use the `:ensure_auth` below for when we need to make sure someone is logged in.
  pipeline :auth do
    plug Kwtool.Accounts.Pipeline
  end

  # We use ensure_auth to fail if there is no one logged in
  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  # coveralls-ignore-start
  pipeline :api do
    plug :accepts, ["json"]
  end

  # coveralls-ignore-stop

  scope "/", KwtoolWeb do
    pipe_through [:browser, :auth]


    get "/", PageController, :index
    get "/sign_up", AuthController, :show
    post "/sign_up", AuthController, :create

    get "/sign_in", SessionController, :new
    post "/sign_in", SessionController, :sign_in
    post "/sign_out", SessionController, :sign_out
  end

  # Definitely logged in scope
  scope "/", KwtoolWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/dashboard", DashboardController, :index
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
