defmodule Todo.Cache do
  use GenServer

  # ---------------------------------------------------------------------------

  def start_link(_) do
    IO.puts("Starting todo cache.")
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def server_process(todo_list_name) do
    GenServer.call(__MODULE__, {:server_process, todo_list_name})
  end

  # ---------------------------------------------------------------------------

  @impl true
  def init(_) do
    Todo.Database.start_link()
    {:ok, %{}}
  end

  @impl true
  def handle_call({:server_process, todo_list_name}, _, todo_servers) do
    case Map.fetch(todo_servers, todo_list_name) do
      {:ok, todo_server} ->
        {:reply, todo_server, todo_servers}

      :error ->
        {:ok, new_server} = Todo.Server.start_link(todo_list_name)
        todo_servers = Map.put(todo_servers, todo_list_name, new_server)
        {:reply, new_server, todo_servers}
    end
  end

end
