defmodule TodoServer2 do
  use GenServer

  #
  # interface functions
  #

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def add_entry(todo_server, new_entry) do
    GenServer.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    GenServer.call(todo_server, {:entries, date})
  end

  #
  # callback functions
  #

  @impl true
  def init(_) do
    {:ok, TodoList2.new()}
  end

  @impl true
  def handle_cast({:add_entry, new_entry}, todo_list) do
    {:noreply, TodoList2.add_entry(todo_list, new_entry)}
  end

  @impl true
  def handle_call({:entries, date}, _, todo_list) do
    {:reply, TodoList2.entries(todo_list, date), todo_list}
  end
end
