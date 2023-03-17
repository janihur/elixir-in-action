# Chapter 8 - Fault-Tolerance Basics

Run `mix` project with `iex`:
```
iex -S mix
```

Run tests:
```
mix test
```

```elixir
iex(1)> Supervisor.start_link([Todo.Cache], strategy: :one_for_one)
Starting todo cache.
Starting todo database.
Starting todo database worker.
Starting todo database worker.
Starting todo database worker.
{:ok, #PID<0.163.0>}

iex(2)> foo = Todo.Cache.server_process("foo list")
Starting todo server for foo list.
#PID<0.170.0>

iex(3)> cache = Process.whereis(Todo.Cache)
#PID<0.164.0>

iex(4)> Process.exit(cache, :kill)
Starting todo cache.
true
Starting todo database.

iex(5)> Process.whereis(Todo.Cache)
#PID<0.173.0>

iex(6)> foo = Todo.Cache.server_process("foo list")
Starting todo server for foo list.
#PID<0.176.0>

iex(7)> foo = Todo.Cache.server_process("foo list")
#PID<0.176.0>
```

```elixir
iex(1)> Todo.System.start_link
Starting todo cache.
Starting todo database.
Starting todo database worker.
Starting todo database worker.
Starting todo database worker.
{:ok, #PID<0.207.0>}

iex(2)> foo = Todo.Cache.server_process("foo list")
Starting todo server for foo list.
#PID<0.214.0>

iex(3)> foo = Todo.Cache.server_process("foo list")
#PID<0.214.0>

iex(4)> Todo.Server.add_entry(foo, %{date: ~D[2023-03-03], title: "do this!"})
:ok

iex(5)> Todo.Server.entries(foo, ~D[2023-03-03])
[%{date: ~D[2023-03-03], id: 6, title: "do this!"}]
```
