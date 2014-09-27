
defmodule FizzBuzz do

  def upto(n) do
    1..n |> Enum.map(&fizzbuzz/1)
  end

  defp fizzbuzz(n) when rem(n, 15) == 0, do: "FizzBuzz"
  defp fizzbuzz(n) when rem(n, 5) == 0, do: "Buzz"
  defp fizzbuzz(n) when rem(n, 3) == 0, do: "Fizz"
  defp fizzbuzz(n), do: n

end

ExUnit.start

defmodule FizzBuzzTest do
  use ExUnit.Case, async: true

  test "generation of FizzBuzz sequence up to the given number" do
    expected =  [1, 2, "Fizz", 4, "Buzz", "Fizz", 7, 8, "Fizz", "Buzz", 11, "Fizz", 13, 14, "FizzBuzz"]
    assert expected == FizzBuzz.upto(15)
  end

end