defmodule Todo.Database do
  use GenServer

  @db_folder "/tmp/todo-persist"

  def start_link do
    IO.puts("Starting todo database.")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def store(key, data) do
    GenServer.call(__MODULE__, {:choose_worker, key})
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    GenServer.call(__MODULE__, {:choose_worker, key})
    |> Todo.DatabaseWorker.get(key)
  end

  @impl GenServer
  def init(_) do
    File.mkdir_p!(@db_folder)
    {:ok, start_workers()}
  end

  @impl GenServer
  def handle_call({:choose_worker, key}, _, workers) do
    worker_key = :erlang.phash2(key, 3)
    {:reply, Map.get(workers, worker_key), workers}
  end

  defp start_workers do
    for i <- 0..2, into: %{} do
      {:ok, pid} = Todo.DatabaseWorker.start_link(@db_folder)
      {i, pid}
    end
  end

end
