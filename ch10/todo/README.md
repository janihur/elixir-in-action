# Chapter 10 - Beyond GenServer

Run `mix` project with `iex`:
```
iex -S mix
```

Run tests:
```
mix test
```

## Task

```elixir
iex(1)> Todo.System.start_link()                        
Starting todo database worker 1
Starting todo database worker 2
Starting todo database worker 3
Starting todo cache.
{:ok, #PID<0.219.0>}
[memory_usage: 27269040, process_count: 75]

iex(2)> foo_list = Todo.Cache.server_process("foo-list")
Starting todo server for foo-list.
#PID<0.229.0>

iex(3)> bar_list = Todo.Cache.server_process("bar-list")
Starting todo server for bar-list.
#PID<0.231.0>
[memory_usage: 27358456, process_count: 77]
[memory_usage: 27377184, process_count: 77]
[memory_usage: 27338648, process_count: 77]
[memory_usage: 27370512, process_count: 77]

iex(4)> todo_lists = Enum.map(1..100, fn id -> Todo.Cache.server_process("list-#{id}") end)
Starting todo server for list-1.
Starting todo server for list-2.
[...]
[#PID<0.233.0>, #PID<0.234.0>, #PID<0.235.0>, #PID<0.236.0>, #PID<0.237.0>, ...]
[memory_usage: 27941776, process_count: 177]
[memory_usage: 27974672, process_count: 177]
```