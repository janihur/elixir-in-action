# https://hexdocs.pm/elixir/typespecs.html
# Elixir is a dynamically typed language, and as such, type specifications are never used by the compiler to optimize or modify code.
# TODO: I could not figure out how to use dialyzer (and thus typespects) without mix yet.

defmodule TodoList2 do
  defstruct auto_id: 1, entries: %{}

  @type t :: %__MODULE__{
    auto_id: Integer.t(),
    entries: Map.t()
  }

  def new(), do: %TodoList2{}

  def new(entries) when is_list(entries) do
    Enum.reduce(
      entries,
      %TodoList2{},
      fn entry, todo_list -> add_entry(todo_list, entry) end
    )
  end

  def add_entry(todo_list, entry) do
    new_entries = Map.put(todo_list.entries, todo_list.auto_id, entry)
    %TodoList2{todo_list | entries: new_entries, auto_id: todo_list.auto_id + 1}
  end

  def entries(todo_list, date) do
    todo_list.entries
    |> Stream.filter(fn {_, entry} -> entry.date == date end)
    |> Enum.map(fn {_, entry} -> entry end)
  end

  def update_entry(todo_list, entry_id, updater_fun) do
    case Map.fetch(todo_list.entries, entry_id) do
      :error ->
        todo_list
      {:ok, old_entry} ->
        new_entry = updater_fun.(old_entry)
        new_entries = Map.put(todo_list.entries, entry_id, new_entry)
        %TodoList2{todo_list | entries: new_entries}
    end
  end

  def delete_entry(todo_list, entry_id) do
    %TodoList2{todo_list | entries: Map.delete(todo_list.entries, entry_id)}
  end
end

defmodule TodoList2.CsvImporter do
  def import(filepath) do
    File.stream!(filepath)
    |> Stream.map(&String.split(String.trim(&1), ","))
    |> Enum.map(fn [date|title] ->
      {_, date} = Date.from_iso8601(date)
      [title | _ ] = title
      %{date: date, title: title}
    end)
  end
end
