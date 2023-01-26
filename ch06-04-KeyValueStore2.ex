defmodule KeyValueStore2 do
  # interface functions used by clients (run in client processes)
  def start, do: ServerProcess2.start(KeyValueStore2)
  def put(pid, key, value), do: ServerProcess2.cast(pid, {:put, key, value})
  def get(pid, key), do: ServerProcess2.call(pid, {:get, key})

  # callback functions used by ServerProcess module (run in server process)
  def init, do: %{}
  def handle_cast({:put, key, value}, state), do: Map.put(state, key, value)
  def handle_call({:get, key}, state), do: {Map.get(state, key), state}
end
