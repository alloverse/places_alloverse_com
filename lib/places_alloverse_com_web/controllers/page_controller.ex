defmodule PlacesAlloverseComWeb.PageController do
  use PlacesAlloverseComWeb, :controller

  def index(conn, _params) do
    # redirect(conn, to: "/place")
    render(conn, "index.html")
  end
end
