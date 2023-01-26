defmodule KeyValueStore1 do
  # interface functions used by clients (run in client processes)
  def start, do: ServerProcess1.start(KeyValueStore1)
  def put(pid, key, value), do: ServerProcess1.call(pid, {:put, key, value})
  def get(pid, key), do: ServerProcess1.call(pid, {:get, key})

  # callback functions used by ServerProcess module (run in server process)
  def init, do: %{}
  def handle_call({:put, key, value}, state), do: {:ok, Map.put(state, key,value)}
  def handle_call({:get, key}, state), do: {Map.get(state, key), state}
end
