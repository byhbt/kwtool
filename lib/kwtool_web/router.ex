defmodule KwtoolWeb.Router do
  use KwtoolWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :auth do
    plug Kwtool.Account.Pipeline
    plug KwtoolWeb.Plugs.SetCurrentUser
  end

  pipeline :ensure_auth do
    plug Guardian.Plug.EnsureAuthenticated
  end

  pipeline :jwt_authenticated do
    plug Guardian.Plug.Pipeline,
      module: Kwtool.Account.Guardian,
      error_handler: KwtoolWeb.Api.V1.ErrorHandler

    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.EnsureAuthenticated
    plug Guardian.Plug.LoadResource
  end


  # coveralls-ignore-start
  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1", KwtoolWeb.Api.V1, as: :api do
    pipe_through [
      :api,
      KwtoolWeb.CheckEmptyBodyParamsPlug
    ]

    post "/sign_in", SessionController, :create
  end

  scope "/api/v1", KwtoolWeb.Api.V1, as: :api do
    pipe_through [
      :api,
      :jwt_authenticated,
      KwtoolWeb.CheckEmptyBodyParamsPlug
    ]

    post "/upload", UploadController, :create
  end


  scope "/", KwtoolWeb do
    pipe_through [:browser, :auth]

    get "/", PageController, :index
    get "/sign_up", AuthController, :show
    post "/sign_up", AuthController, :create

    get "/sign_in", SessionController, :new
    post "/sign_in", SessionController, :create

    delete "/sign_out", SessionController, :delete
  end

  # Authenticated scope
  scope "/", KwtoolWeb do
    pipe_through [:browser, :auth, :ensure_auth]

    get "/home", HomeController, :index

    get "/uploads", UploadController, :index
    post "/uploads", UploadController, :create

    resources "/keywords", KeywordController, only: [:index, :show]
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
