# usually you don't need to do this yourself but you'll use
# standard GenServer abstraction

# stateful server

defmodule DatabaseServer2 do
  #
  # interface (public function(s))
  #

  def start do
    spawn(fn ->
      connection = Enum.random(100..999) # initial state
      loop(connection)
    end)
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

  defp loop(connection) do
    receive do
      {:run_query, caller, query_def} ->
        send(caller, {:query_result, run_query(connection, query_def)})
    end
    loop(connection) # tail-recursion
  end

  defp run_query(connection, query_def) do
    sleep_time = Enum.random(1_000..3_000)
    sleep_time |> Process.sleep()
    "(connection #{connection})(result \"#{query_def} result\")(slept #{sleep_time})"
  end
end
