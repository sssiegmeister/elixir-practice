defmodule Practice.Palindrome do

  def palindrome?(s) when s == "" do
  	true
  end

  def palindrome?(s) do
    String.ends_with?(s, String.first(s)) and palindrome?(String.trim(s, String.first(s)))
  end

end