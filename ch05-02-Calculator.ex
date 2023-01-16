defmodule Calculator do
  def start do
    spawn(fn -> loop(0) end)
  end

  def value(server_pid) do
    send(server_pid, {:value, self()}) # message to self
    receive do
      {:response, value} -> value
    end
  end

  def add(server_pid, value), do: send(server_pid, {:add, value})
  def sub(server_pid, value), do: send(server_pid, {:sub, value})
  def mul(server_pid, value), do: send(server_pid, {:mul, value})
  def div(server_pid, value), do: send(server_pid, {:div, value})

  defp loop(current_value) do
    sleep_time = Enum.random(1_000..3_000) # simulates extensive calculations
    new_value =
      receive do
        {:value, caller} ->
          send(caller, {:response, current_value})
          current_value

        {:add, value} ->
          sleep_time |> Process.sleep()
          current_value + value
        {:sub, value} ->
          sleep_time |> Process.sleep()
          current_value - value
        {:mul, value} ->
          sleep_time |> Process.sleep()
          current_value * value
        {:div, value} ->
          sleep_time |> Process.sleep()
          current_value / value

        invalid_request ->
          IO.puts("invalid request #{inspect invalid_request}")
          current_value
      end
    loop(new_value)
  end

end
