defmodule Watercooler.ChatRoom do
  use Phoenix.Channel

  def join(socket, "chat_room", _message) do
    {:ok, socket}
  end

  def join(socket, _no, _message) do
    {:error, socket, :unauthorized}
  end

  def event(socket, "chat_room:join", payload = %{"nickname" => nickname}) do
    broadcast socket, "chat_room:joined", %{nickname: nickname, users: [%{nickname: "ChatBot"}, %{nickname: nickname}]}
    socket
  end

  def event(socket, "chat_room:message", payload = %{"nickname" => _nickname, "message" => _message}) do
    broadcast socket, "chat_room:message", payload
    socket
  end

  def event(socket, "chat_room:leave", payload = %{"nickname" => nickname}) do
    broadcast socket, "chat_room:left", %{nickname: nickname, users: [%{nickname: "ChatBot"}]}
    socket
  end

end