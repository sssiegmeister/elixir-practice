defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def split(str) do
    String.split(str, ~r/\s+/)
  end

  def tag_tokens(tokens) do
    Enum.map(tokens, fn(t) -> tag_token(t) end)
  end

  def tag_token(token) do
    cond do
        Regex.match?(~r/^(\+|\-|\*|\/)/, token) ->
            [:op, token]
        Regex.match?(~r/^[0-9]*$/, token) ->
            [:num, parse_float(token)]
    end
  end

  def order_ops(op, result)
    when length(elem(result, 0)) == 0 do
      {[op], elem(result, 1)}
    end


  def order_ops(op, result) do
    order = %{"-" => 0, "+" => 0, "%" => 1, "*" => 1}

    [head | tail] = if length(elem(result, 0)) > 1 do elem(result, 0) else [hd(elem(result, 0)) | []] end
    if (order[op] < order[head]) do
        order_ops(op, {tail, elem(result, 1) ++ [head]})
    else
        {[op] ++ elem(result, 0), elem(result, 1)}
    end
  end

  def postfix(tokens, op_stack, stack)
    when length(tokens) == 0 do
      stack ++ op_stack
    end

  def postfix(tokens, op_stack, stack) do
    [head | tail] = tokens
    cond do
        Enum.member?(head, :num) ->
          postfix(tail, op_stack, stack ++ [List.last(head)])
        Enum.member?(head, :op) ->
          if length(op_stack) == 0 do
            postfix(tail, [List.last(head)], stack)
          else
            {new_ops, new_stack} = order_ops(List.last(head), {op_stack, stack})
            postfix(tail, new_ops, new_stack)
          end
        end
  end

  def eval(postfix_stack, eval_stack) 
    when length(postfix_stack) == 0 do
      hd(eval_stack)
    end
    
  def eval(postfix_stack, eval_stack)
    when hd(postfix_stack) == "+" do
      [left, right | tail] = eval_stack
      eval(tl(postfix_stack), [right + left] ++ tail)
    end

  def eval(postfix_stack, eval_stack)
    when hd(postfix_stack) == "-" do
      [left, right | tail] = eval_stack
      eval(tl(postfix_stack), [right - left] ++ tail)
    end

  def eval(postfix_stack, eval_stack)
    when hd(postfix_stack) == "*" do
      [left, right | tail] = eval_stack
      eval(tl(postfix_stack), [right * left] ++ tail)
    end

  def eval(postfix_stack, eval_stack)
    when hd(postfix_stack) == "/" do
      [left, right | tail] = eval_stack
      eval(tl(postfix_stack), [right / left] ++ tail)
    end

  def eval(postfix_stack, eval_stack) do
      eval(tl(postfix_stack), [hd(postfix_stack)] ++ eval_stack)
    end



  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.

    expr
    |> String.split(~r/\s+/)
    |> tag_tokens
    |> postfix([], [])
    |> eval([])

  end
end
