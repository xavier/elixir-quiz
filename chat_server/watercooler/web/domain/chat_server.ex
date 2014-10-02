defmodule Watercooler.Domain.ChatServer do
  use GenServer

  @moduledoc """

  A registry of chat rooms

  """

  @server_name :chat_server

  ## Client API

  @doc """
  Starts the registry.
  """
  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, :ok, name: @server_name)
  end

  @doc """
  Looks up the chat room pid for `name` stored in `server`.

  Returns `{:ok, room}` if the room exists, `:error` otherwise.
  """
  def room(name) do
    GenServer.call(@server_name, {:room, name})
  end

  @doc """
  Ensures there is a chat room associated to the given `name` in `server`.
  """
  def create_room(name) do
    GenServer.cast(@server_name, {:create_room, name})
  end

  ## Server Callbacks

  def init(:ok) do
    {:ok, HashDict.new}
  end

  def handle_call({:room, name}, _from, rooms) do
    {:reply, HashDict.fetch(rooms, name), rooms}
  end

  def handle_cast({:create_room, name}, rooms) do
    if HashDict.get(rooms, name) do
      {:noreply, rooms}
    else
      {:ok, room} = Watercooler.Domain.ChatRoom.start_link(name)
      {:noreply, HashDict.put(rooms, name, room)}
    end
  end
end