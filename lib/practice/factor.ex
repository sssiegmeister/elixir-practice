defmodule Practice.Factors do

  def parse_int(text) do
    IO.inspect(text)
    {n, _} = Integer.parse(text)
    n
  end

  def factor(num) do
    prime_factors(parse_int(num)) |> inspect
  end

  def prime_factors(num , next \\ 2)
  def prime_factors(num, 2) do
    cond do
      rem(num, 2) == 0 -> [2 | prime_factors(div(num, 2))]
      4 > num          -> [num]
      true             -> prime_factors(num, 3)
    end
  end
  def prime_factors(num, next) do
    cond do
      rem(num, next) == 0 -> [next | prime_factors(div(num, next))]
      next + next > num   -> [num]
      true                -> prime_factors(num, next + 2)
    end
  end

end