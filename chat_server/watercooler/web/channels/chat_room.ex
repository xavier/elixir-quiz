defmodule Watercooler.ChatRoom do
  use Phoenix.Channel

  alias Watercooler.Domain.ChatServer, as: Server
  alias Watercooler.Domain.ChatRoom,   as: Room

  def join(socket, "chat_room", _message) do
    {:ok, socket}
  end

  def join(socket, _no, _message) do
    {:error, socket, :unauthorized}
  end

  @room_name "The Watercooler"

  def event(socket, "chat_room:join", payload = %{"nickname" => nickname}) do
    Server.create_room(@room_name)
    {:ok, room} = Server.room(@room_name)
    Room.join(room, nickname)
    broadcast socket, "chat_room:joined", %{nickname: nickname, users: Room.users(room)}
    socket
  end

  def event(socket, "chat_room:leave", payload = %{"nickname" => nickname}) do
    {:ok, room} = Server.room(@room_name)
    Room.leave(room, nickname)
    broadcast socket, "chat_room:left", %{nickname: nickname, users: Room.users(room)}
    socket
  end

  def event(socket, "chat_room:message", payload = %{"nickname" => _nickname, "message" => _message}) do
    broadcast socket, "chat_room:message", payload
    socket
  end

end