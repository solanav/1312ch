defmodule AcabWeb.Router do
  use AcabWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AcabWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AcabWeb do
    pipe_through :browser

    live "/", PageLive, :index
  
    # Release
    live "/:board_url", BoardLive.Show, :show
    live "/:board_url/:thread_id", ThreadLive.Show, :show

    # Boards
    live "/boards", BoardLive.Index, :index
    live "/boards/new", BoardLive.Index, :new
    live "/boards/:id/edit", BoardLive.Index, :edit

    live "/boards/:id/show/edit", BoardLive.Show, :edit
    live "/boards/:id/new_thread", BoardLive.Show, :new_thread

    # Threads
    live "/threads", ThreadLive.Index, :index
    live "/threads/new", ThreadLive.Index, :new
    live "/threads/:id/edit", ThreadLive.Index, :edit

    live "/threads/:id/show/edit", ThreadLive.Show, :edit
    live "/threads/:id/new_reply", ThreadLive.Show, :new_reply

    # Replies
    live "/replies", ReplyLive.Index, :index
    live "/replies/new", ReplyLive.Index, :new
    live "/replies/:id/edit", ReplyLive.Index, :edit

    live "/replies/:id", ReplyLive.Show, :show
    live "/replies/:id/show/edit", ReplyLive.Show, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", AcabWeb do
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
      live_dashboard "/dashboard", metrics: AcabWeb.Telemetry
    end
  end
end
