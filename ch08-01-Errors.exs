defmodule Errors do
  def try_helper(fun) do
    try do
      fun.()
      IO.puts("no error")
    catch error_type, error_value -> # pattern matching
      IO.puts("---")
      IO.puts("error:")
      IO.puts("  type:  #{inspect(error_type)}")
      IO.puts("  value: #{inspect(error_value)}")
    after
      IO.puts("after block")
    end
  end
end

Errors.try_helper(fn -> raise("Kernel.raise: error wrapped w/ Elixir struct") end)
Errors.try_helper(fn -> :erlang.error(":erlang.error: plain term") end)
Errors.try_helper(fn -> throw("Kernel.throw") end)
Errors.try_helper(fn -> exit("Kernel.exit") end)
