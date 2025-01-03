defmodule RedezvousWeb.Router do
  use RedezvousWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :put_root_layout, html: {RedezvousWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]

    plug Plug.Parsers,
      parsers: [:urlencoded, :multipart, :json, Absinthe.Plug.Parser],
      pass: ["*/*"],
      json_decoder: Jason

    plug RedezvousWeb.Contexts.AuthContext
  end

  scope "/" do
    pipe_through :api

    if Mix.env() == :dev do
      forward "/graphiql", Absinthe.Plug.GraphiQL,
        schema: RedezvousWeb.Schema,
        context: %{pubsub: RedezvousWeb.Endpoint}
    end

    forward "/", Absinthe.Plug, schema: RedezvousWeb.Schema
  end
end
