# Chapter 7 - Todo Application

Run `mix` project with `iex`:
```
iex -S mix
```

Run tests:
```
mix test
```

## Todo V1

Create 100000 lists:
```elixir
iex(1)> :erlang.system_info(:process_count)
64

iex(2)> {:ok, cache} = Todo.Cache.start()
{:ok, #PID<0.155.0>}

iex(3)> Enum.each(1.. 100_000, fn index -> Todo.Cache.server_process(cache, "list #{index}") end)
:ok

iex(4)> :erlang.system_info(:process_count)
100065
```

TODO: Example how to send a message to each server

Save persistent entry:
```elixir
iex(1)> {:ok, cache} = Todo.Cache.start()
{:ok, #PID<0.161.0>}

iex(2)> foo = Todo.Cache.server_process(cache, "foo list")
#PID<0.163.0>

iex(3)> Todo.Server.add_entry(foo, %{date: ~D[2023-02-07], title: "dentist"})
:ok
```

Read persisted entry in another `iex` session:
```elixir
iex(1)> {:ok, cache} = Todo.Cache.start()
{:ok, #PID<0.161.0>}

iex(2)> foo = Todo.Cache.server_process(cache, "foo list")
#PID<0.163.0>

iex(3)> Todo.Server.entries(foo, ~D[2023-02-07])
[%{date: ~D[2023-02-07], id: 1, title: "dentist"}]
```

## Todo V2

The same than V1 but with pooling. The user inteface is the same than in V1.