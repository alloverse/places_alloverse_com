defmodule PlacesAlloverseComWeb.PageController do
  use PlacesAlloverseComWeb, :controller

  def index(conn, _params) do
    redirect(conn, to: "/place")
  end
end
