defmodule RedezvousWeb.Router do
  use RedezvousWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RedezvousWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: RedezvousWeb.Schema,
      interface: :simple,
      context: %{pubsub: RedezvousWeb.Endpoint}

    forward "/", Absinthe.Plug, schema: RedezvousWeb.Schema
  end
end
