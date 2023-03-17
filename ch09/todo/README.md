# Chapter 9 - Isolating Error Effects

Run `mix` project with `iex`:
```
iex -S mix
```

Run tests:
```
mix test
```

First version:

```elixir
iex(1)> Todo.System.start_link                  
Starting todo database.
Starting todo database worker.
Starting todo database worker.
Starting todo database worker.
Starting todo cache.
{:ok, #PID<0.163.0>}

iex(2)> Process.exit(Process.whereis(Todo.Database), :kill)
true
Starting todo database.
Starting todo database worker.
Starting todo database worker.
Starting todo database worker.

iex(3)> Process.exit(Process.whereis(Todo.Cache), :kill)   
Starting todo cache.
true
```

Second version:

```elixir
iex(1)> Todo.System.start_link()
Starting todo database worker 1
Starting todo database worker 2
Starting todo database worker 3
Starting todo cache.
{:ok, #PID<0.166.0>}

iex(2)> [{worker_pid, _}] = Registry.lookup(Todo.ProcessRegistry, {Todo.DatabaseWorker, 2})
[{#PID<0.171.0>, nil}]

iex(3)> Process.exit(worker_pid, :kill)
true
Starting todo database worker 2
```

Third version:

```elixir
iex(1)> Todo.System.start_link()       
Starting todo database worker 1
Starting todo database worker 2
Starting todo database worker 3
Starting todo cache.
{:ok, #PID<0.163.0>}

iex(2)> foo_list = Todo.Cache.server_process("foo-list")
Starting todo server for foo-list.
#PID<0.172.0>

iex(3)> foo_list = Todo.Cache.server_process("foo-list")
Starting todo server for foo-list.
#PID<0.172.0>

iex(4)> bar_list = Todo.Cache.server_process("bar-list")
Starting todo server for bar-list.
#PID<0.175.0>

iex(5)> Process.exit(foo_list, :kill)
true

iex(6)> foo_list = Todo.Cache.server_process("foo-list")
Starting todo server for foo-list.
#PID<0.178.0>

iex(7)> bar_list = Todo.Cache.server_process("bar-list")
Starting todo server for bar-list.
#PID<0.175.0>
```