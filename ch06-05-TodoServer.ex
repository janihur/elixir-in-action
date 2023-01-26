defmodule TodoServer do
  #
  # interface functions
  #
  def start do
    ServerProcess2.start(TodoServer)
  end

  def add_entry(todo_server, new_entry) do
    ServerProcess2.cast(todo_server, {:add_entry, new_entry})
  end

  def entries(todo_server, date) do
    ServerProcess2.call(todo_server, {:entries, date})
  end

  #
  # callback functions
  #
  def init do
    TodoList2.new()
  end

  def handle_cast({:add_entry, new_entry}, todo_list) do
    TodoList2.add_entry(todo_list, new_entry)
  end

  def handle_call({:entries, date}, todo_list) do
    {TodoList2.entries(todo_list, date), todo_list}
  end
end
