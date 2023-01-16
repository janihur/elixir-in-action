# usually you don't need to do this yourself but you'll use
# standard GenServer abstraction

# stateless server

defmodule DatabaseServer1 do
  #
  # interface (public function(s))
  #

  def start do
    spawn(&loop/0)
  end

  def run_async(server_pid, query_def) do
    send(server_pid, {:run_query, self(), query_def})
  end

  def get_result do
    receive do
      {:query_result, result} -> result
      after
        5000 -> {:error, :timeout}
    end
  end

  #
  # implementation (private function(s))
  #

  defp loop do
    receive do
      {:run_query, caller, query_def} ->
        send(caller, {:query_result, run_query(query_def)})
    end
    loop() # tail-recursion
  end

  defp run_query(query_def) do
    Enum.random(1_000..3_000) |> Process.sleep()
    "#{query_def} result"
  end
end
