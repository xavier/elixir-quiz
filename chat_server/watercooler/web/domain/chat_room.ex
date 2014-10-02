
defmodule Watercooler.Domain.ChatRoom do

  @moduledoc """

  Provides an API to manage the state of a chat room

  """

  defmodule State do
    defstruct name: nil, users: [], messages: []
  end

  def start_link(name) do
    Agent.start_link(fn -> %State{name: name} end)
  end

  def users(room) do
    Agent.get(room, fn state -> state.users end)
  end

  def join(room, nickname) do
    Agent.update(room, fn state ->
      users = [%{nickname: nickname} | state.users]
      users = Enum.sort_by(users, fn (%{nickname: nickname}) -> String.downcase(nickname) end)
      %{state | users: users}
    end)
  end

  def leave(room, nickname) do
    Agent.update(room, fn state ->
      %{state | users: List.delete(state.users, %{nickname: nickname})}
    end)
  end

end