defmodule RunLengthEncoding do

  def encode(input) do
    input |> String.codepoints |> compress([])
  end

  defp compress([], compressed), do: format(compressed, [])
  defp compress([c | tail], [{c, n} | compressed]), do: compress(tail, [{c, n+1} | compressed])
  defp compress([c | tail], compressed),            do: compress(tail, [{c, 1} | compressed])

  defp format([], formatted), do: Enum.join(formatted)
  defp format([{c, n} | compressed], formatted), do: format(compressed, ["#{n}#{c}"|formatted])
  defp format([c | compressed], formatted),      do: format(compressed, [c|formatted])

end

ExUnit.start

defmodule RunLengthEncodingTest do
  use ExUnit.Case, async: true

  test "encoding of sample string" do
    input    = "JJJTTWPPMMMMYYYYYYYYYVVVVVV"
    expected = "3J2T1W2P4M9Y6V"
    assert expected == RunLengthEncoding.encode(input)
  end

end