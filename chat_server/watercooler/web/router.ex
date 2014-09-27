defmodule Watercooler.Router do
  use Phoenix.Router

  get "/", Watercooler.PageController, :index, as: :pages

end
