defmodule SimpleRegistry do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def register(name) do
    GenServer.call(__MODULE__, {:register, name, self()})
  end

  def whereis(name) do
    GenServer.call(__MODULE__, {:whereis, name})
  end

  @impl GenServer
  def init(_) do
    Process.flag(:trap_exit, true)
    {:ok, %{}}
  end

  @impl GenServer
  def handle_call({:register, name, pid}, _, registry) do
    case Map.get(registry, name) do
      nil ->
        Process.link(pid)
        {:reply, :ok, Map.put(registry, name, pid)}
      _ ->
        {:reply, :error, registry}
    end

  end

  @impl GenServer
  def handle_call({:whereis, name}, _, registry) do
    {:reply, Map.get(registry, name), registry}
  end

  @impl GenServer
  def handle_info({:EXIT, pid, _reason}, registry) do
    {:noreply, deregister_pid(registry, pid)}
  end

  defp deregister_pid(registry, pid) do
    # We'll walk through each {key, value} item, and keep those elements whose
    # value is different to the provided pid.
    registry
    |> Enum.reject(fn {_key, registered_process} -> registered_process == pid end)
    |> Enum.into(%{})
  end
end
