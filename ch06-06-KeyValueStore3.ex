defmodule KeyValueStore3 do
  use GenServer

  #
  # interface functions
  #

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def put(pid, key, value) do
    GenServer.cast(pid, {:put, key, value})
  end

  def get(pid, key) do
    GenServer.call(pid, {:get, key})
  end

  def stop(pid) do
    GenServer.stop(pid)
  end

  #
  # callback functions for GenServer behaviour
  #

  @impl true
  def init(_) do
    :timer.send_interval(5000,  :cleanup1) # Erlang function
    :timer.send_interval(10000, :cleanup2) # Erlang function
    {:ok, %{}}
  end

  @impl true
  def handle_cast({:put, key, value}, state) do
    {:noreply, Map.put(state, key, value)}
  end

  @impl true
  def handle_call({:get, key}, _, state) do
    {:reply, Map.get(state, key), state}
  end

  @impl true
  def handle_info(:cleanup1, state) do
    IO.puts(":cleanup1 message received")
    {:noreply, state}
  end

  @impl true
  def handle_info(:cleanup2, state) do
    IO.puts(":cleanup2 message received")
    {:noreply, state}
  end

  @impl true
  def terminate(:normal, _) do
    IO.puts("cleanup before server is terminated")
  end
end
