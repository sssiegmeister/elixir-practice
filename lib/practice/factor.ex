defmodule Practice.Factors do

  def parse_int(text) do
    {num, _} = Integer.parse(text)
    num
  end

  def factor(x) do
    factor(parse_int(x), 2, [], false)
  end

  def factor(x, fact, acc, flag) when
    x == 1 do
      acc |> inspect  
    end

  def factor(x, fact, acc, flag) when
    flag do
      factor(div(x, fact), 2, acc ++ [fact], Integer.mod(div(x, fact), 2) == 0)
    end

  def factor(x, fact, acc, flag) do
      factor(x, fact + 1, acc, Integer.mod(x, fact + 1) == 0)
    end
end