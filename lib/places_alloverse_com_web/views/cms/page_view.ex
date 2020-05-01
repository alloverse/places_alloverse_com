defmodule PlacesAlloverseComWeb.CMS.PageView do
  use PlacesAlloverseComWeb, :view

  alias PlacesAlloverseCom.CMS

  def author_name(%CMS.Page{author: author}) do
    author.user.name
  end
end
