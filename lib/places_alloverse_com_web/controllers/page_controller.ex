defmodule PlacesAlloverseComWeb.PageController do
  use PlacesAlloverseComWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
