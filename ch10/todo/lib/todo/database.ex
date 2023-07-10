defmodule Todo.Database do

  @pool_size 3
  @db_folder "/tmp/todo-persist"

  def start_link do
    File.mkdir_p!(@db_folder)
    children = Enum.map(1..@pool_size, &worker_spec/1)
    Supervisor.start_link(children, strategy: :one_for_one)
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def store(key, data) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.store(key, data)
  end

  def get(key) do
    key
    |> choose_worker()
    |> Todo.DatabaseWorker.get(key)
  end

  defp choose_worker(key) do
    :erlang.phash2(key, @pool_size) + 1
  end

  defp worker_spec(worker_id) do
    default_worker_spec = {Todo.DatabaseWorker, {@db_folder, worker_id}}
    Supervisor.child_spec(default_worker_spec, id: worker_id)
  end



  # @impl GenServer
  # def init(_) do
  #   File.mkdir_p!(@db_folder)
  #   {:ok, start_workers()}
  # end

  # @impl GenServer
  # def handle_call({:choose_worker, key}, _, workers) do
  #   worker_key = :erlang.phash2(key, 3)
  #   {:reply, Map.get(workers, worker_key), workers}
  # end

  # defp start_workers do
  #   for i <- 0..2, into: %{} do
  #     {:ok, pid} = Todo.DatabaseWorker.start_link(@db_folder)
  #     {i, pid}
  #   end
  # end

end
