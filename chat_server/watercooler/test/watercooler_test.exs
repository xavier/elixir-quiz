defmodule WatercoolerTest do
  use ExUnit.Case

  alias Watercooler.Domain.ChatRoom, as: ChatRoom

  setup do
    {:ok, chat_room} = ChatRoom.start_link("TestRoom")
    {:ok, [room: chat_room]}
  end

  test "no users by default", context do
    assert [] == ChatRoom.users(context[:room])
  end

  test "joining a room", context do
    ChatRoom.join(context[:room], "Alice")
    assert [%{nickname: "Alice"}] == ChatRoom.users(context[:room])
  end

  test "users are sorted alphabetically", context do
    ChatRoom.join(context[:room], "Bob")
    ChatRoom.join(context[:room], "alice")
    ChatRoom.join(context[:room], "xeno")
    expected = [%{nickname: "alice"}, %{nickname: "Bob"}, %{nickname: "xeno"}]
    assert expected == ChatRoom.users(context[:room])
  end

  test "leaving a room", context do
    ChatRoom.join(context[:room], "Alice")
    ChatRoom.join(context[:room], "Bob")
    ChatRoom.leave(context[:room], "Alice")
    assert [%{nickname: "Bob"}] == ChatRoom.users(context[:room])
  end

end
