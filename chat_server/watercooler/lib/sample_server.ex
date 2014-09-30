defmodule Watercooler.SampleServer do

  use GenServer

  def start_link(number) do
    IO.inspect "server start link:"
    IO.inspect number

    # GenServer.start_link(__MODULE__, number, [])

    GenServer.start_link(__MODULE__, number, name: :my_super_cool_name)

    # here's how you start a named gen_server  in pure Erlang:
    # :gen_server.start_link({:local, :stacker}, __MODULE__, number, [])
  end

  def init(number) do
    IO.inspect "server init:"
    IO.inspect number

    { :ok, number }
  end


  def handle_call({:sum, new_number}, _from, accu) do
    new = new_number + accu
    { :reply, new, new }
  end
  def handle_call({:min, new_number}, _from, accu) do
    new = accu - new_number
    { :reply, new, new }
  end

end
