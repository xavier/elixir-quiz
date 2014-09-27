defmodule Watercooler.Router do
  use Phoenix.Router
  use Phoenix.Router.Socket, mount: "/ws"

  channel "chat_room", Watercooler.ChatRoom

  get "/", Watercooler.PageController, :index, as: :pages

end
