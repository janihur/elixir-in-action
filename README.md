# Code for Elixir in Action

My companion code and notes for book [Elixir in Action (Second Edition)](https://www.manning.com/books/elixir-in-action-second-edition) by Saša Jurić. The original book example code is available in https://github.com/sasa1977/elixir-in-action

Compile:
```bash
elixirc <FILE>.ex
```

All `.beam` files located in the current working directory are loaded automatically when `iex` is started.

Save `iex` command history:
```bash
export ELIXIR_ERL_OPTIONS="-kernel shell_history enabled"
```

## Chapter 4 - Fraction

```elixir
iex(1)> Fraction.sub(Fraction.new(2,5), Fraction.new(1,4)) |> IO.inspect |> Fraction.value
%Fraction{a: 3, b: 20}
0.15

iex(2)> Fraction.new(1,3) |> IO.puts   
1 / 3
:ok
```

## Chapter 4 - TodoList1

```elixir
iex(1)> todos = TodoList1.new
%{}

iex(2)> TodoList1.add_entry(todos, ~D[2023-01-19], "lorem ipsum")
%{~D[2023-01-19] => ["lorem ipsum"]}

iex(3)> todos = TodoList1.add_entry(todos, ~D[2023-01-19], "lorem ipsum")
%{~D[2023-01-19] => ["lorem ipsum"]}

iex(4)> todos = TodoList1.add_entry(todos, ~D[2023-01-20], "dolor sit amet")
%{~D[2023-01-19] => ["lorem ipsum"], ~D[2023-01-20] => ["dolor sit amet"]}

iex(5)> todos = TodoList1.add_entry(todos, ~D[2023-01-20], "consectetur adipiscing")
%{
  ~D[2023-01-19] => ["lorem ipsum"],
  ~D[2023-01-20] => ["consectetur adipiscing", "dolor sit amet"]
}

iex(6)> todos = TodoList1.add_entry(todos, ~D[2023-01-21], "sed do eiusmod")        
%{
  ~D[2023-01-19] => ["lorem ipsum"],
  ~D[2023-01-20] => ["consectetur adipiscing", "dolor sit amet"],
  ~D[2023-01-21] => ["sed do eiusmod"]
}

iex(7)> TodoList1.entries(todos, ~D[2023-01-21])
["sed do eiusmod"]
```

## Chapter 4 - TodoList2

```elixir
iex(1)> todos = TodoList2.new |> 
TodoList2.add_entry(%{date: ~D[2023-01-19], title: "lorem ipsum"}) |> 
TodoList2.add_entry(%{date: ~D[2023-01-19], title: "dolor sit amet"}) |> 
TodoList2.add_entry(%{date: ~D[2023-01-20], title: "consectetur adipiscing elit"})
%TodoList2{
  auto_id: 4,
  entries: %{
    1 => %{date: ~D[2023-01-19], title: "lorem ipsum"},
    2 => %{date: ~D[2023-01-19], title: "dolor sit amet"},
    3 => %{date: ~D[2023-01-20], title: "consectetur adipiscing elit"}
  }
}

iex(2)> todos = TodoList2.update_entry(todos, 2, &Map.put(&1, :date, ~D[2023-01-20]))
%TodoList2{
  auto_id: 4,
  entries: %{
    1 => %{date: ~D[2023-01-19], title: "lorem ipsum"},
    2 => %{date: ~D[2023-01-20], title: "dolor sit amet"},
    3 => %{date: ~D[2023-01-20], title: "consectetur adipiscing elit"}
  }
}

iex(3)> todos = TodoList2.delete_entry(todos, 2)
%TodoList2{
  auto_id: 4,
  entries: %{
    1 => %{date: ~D[2023-01-19], title: "lorem ipsum"},
    3 => %{date: ~D[2023-01-20], title: "consectetur adipiscing elit"}
  }
}
```

Importing from CSV:
```elixir
iex(1)> todos = TodoList2.CsvImporter.import("todo-list.csv") |> TodoList2.new
%TodoList2{
  auto_id: 4,
  entries: %{
    1 => %{date: ~D[2023-01-20], title: "Dentist"},
    2 => %{date: ~D[2023-01-21], title: "Shopping"},
    3 => %{date: ~D[2023-01-22], title: "Movies"}
  }
}
```
## Chapter 5 - DatabaseServer

The usage of both `DatabaseServer1` (stateless) and `DatabaseServer2` (stateful) is identical.

Sequential usage:
```elixir
iex(1)> pid = DatabaseServer1.start
#PID<0.108.0>

iex(2)> DatabaseServer.run_async(pid, "QONE")
{:run_query, #PID<0.106.0>, "QONE"}

iex(3)> DatabaseServer1.run_async(pid, "QTWO")
{:run_query, #PID<0.106.0>, "QTWO"}

iex(4)> DatabaseServer1.get_result
"QONE result"

iex(5)> DatabaseServer1.get_result
"QTWO result"

iex(6)> DatabaseServer1.get_result
{:error, :timeout}
```

Parallel usage:
```elixir
iex(8)> pool = Enum.map(1..100, fn _ -> DatabaseServer1.start end)
[#PID<0.117.0>, #PID<0.118.0>, #PID<0.119.0>, #PID<0.120.0>, #PID<0.121.0>,
 #PID<0.122.0>, #PID<0.123.0>, #PID<0.124.0>, #PID<0.125.0>, #PID<0.126.0>,
 #PID<0.127.0>, #PID<0.128.0>, #PID<0.129.0>, #PID<0.130.0>, #PID<0.131.0>,
 #PID<0.132.0>, #PID<0.133.0>, #PID<0.134.0>, #PID<0.135.0>, #PID<0.136.0>,
 #PID<0.137.0>, #PID<0.138.0>, #PID<0.139.0>, #PID<0.140.0>, #PID<0.141.0>,
 #PID<0.142.0>, #PID<0.143.0>, #PID<0.144.0>, #PID<0.145.0>, #PID<0.146.0>,
 #PID<0.147.0>, #PID<0.148.0>, #PID<0.149.0>, #PID<0.150.0>, #PID<0.151.0>,
 #PID<0.152.0>, #PID<0.153.0>, #PID<0.154.0>, #PID<0.155.0>, #PID<0.156.0>,
 #PID<0.157.0>, #PID<0.158.0>, #PID<0.159.0>, #PID<0.160.0>, #PID<0.161.0>,
 #PID<0.162.0>, #PID<0.163.0>, #PID<0.164.0>, #PID<0.165.0>, #PID<0.166.0>, ...]

iex(9)> Enum.each(1..20, fn query_def -> pool |> Enum.at(Enum.random(1..100)-1) |> DatabaseServer1.run_async(query_def) end)
:ok

iex(10)> Enum.map(1..20, fn _ -> DatabaseServer1.get_result end)
["7 result", "20 result", "12 result", "11 result", "18 result", "10 result",
 "14 result", "4 result", "19 result", "13 result", "2 result", "15 result",
 "1 result", "3 result", "8 result", "9 result", "5 result", "6 result",
 "16 result", "17 result"]
```

## Chapter 5 - Calculator

```elixir
iex(1)> pid = Calculator.start
#PID<0.108.0>

iex(2)> Calculator.value(pid)
0

iex(3)> Calculator.add(pid, 10)
{:add, 10}

iex(4)> Calculator.sub(pid, 5)
{:sub, 5}

iex(5)> Calculator.mul(pid, 3)
{:mul, 3}

iex(6)> Calculator.div(pid, 5)
{:div, 5}

iex(7)> Calculator.value(pid)
3.0
```

## Chapter 6 - Generic Server Process #1

The generic server process is hidden behind `KeyValueStore1` interface functions `start/0`, `put/3` and `get/2`:
```elixir
iex(1)> kv = KeyValueStore1.start
#PID<0.112.0>

iex(2)> KeyValueStore1.put(kv, :foo, "this is foo (atom)")
:ok

iex(3)> KeyValueStore1.put(kv, "foo", "this is foo (string)")
:ok

iex(4)> KeyValueStore1.put(kv, :bar, "this is bar (atom)")   
:ok

iex(5)> KeyValueStore1.get(kv, :foo)
"this is foo (atom)"

iex(6)> KeyValueStore1.get(kv, "foo")
"this is foo (string)"

iex(7)> KeyValueStore1.get(kv, "zoo")
nil
```

## Chapter 6 - Generic Server Process #2

Adds support for asyncronous calls (i.e. _cast_ in Erlang ecosystem jargon).
```elixir
iex(1)> kv = KeyValueStore2.start                         
#PID<0.112.0>

iex(2)> KeyValueStore2.put(kv, :foo, "this is foo (atom)")
{:cast, {:put, :foo, "this is foo (atom)"}}

iex(3)> KeyValueStore2.get(kv, :foo)                      
"this is foo (atom)"

iex(4)> KeyValueStore2.get(kv, :bar)
nil
```

## Chapter 6 - TodoList with Generic Server Process

```elixir
iex(1)> pid = TodoServer.start()
#PID<0.112.0>

iex(2)> TodoServer.add_entry(pid, %{date: ~D[2023-01-26], title: "lorem ipsum"})
{:cast, {:add_entry, %{date: ~D[2023-01-26], title: "lorem ipsum"}}}

iex(3)> TodoServer.add_entry(pid, %{date: ~D[2023-01-27], title: "dolor sit amet"})
{:cast, {:add_entry, %{date: ~D[2023-01-27], title: "dolor sit amet"}}}

iex(4)> TodoServer.entries(pid, ~D[2023-01-26])
[%{date: ~D[2023-01-26], title: "lorem ipsum"}]

iex(5)> TodoServer.entries(pid, ~D[2023-01-27])
[%{date: ~D[2023-01-27], title: "dolor sit amet"}]

iex(6)> TodoServer.entries(pid, ~D[2023-01-28])
[]
```

## Chapter 6 - KeyValueStore with Elixir GenServer

Inspect runtime date with: [`__info__/1`](https://hexdocs.pm/elixir/1.14.1/Module.html#c:__info__/1).

```elixir
iex(1)> KeyValueStore3.__info__(:functions)
[
  child_spec: 1,
  code_change: 3,
  handle_call: 3,
  handle_cast: 2,
  handle_info: 2,
  init: 1,
  terminate: 2
]
```

```elixir
iex(1)> {:ok, kv} = KeyValueStore3.start()
{:ok, #PID<0.117.0>}

iex(2)> KeyValueStore3.put(kv, :foo, "this is foo (atom)")
:ok

iex(3)> KeyValueStore3.get(kv, :foo)
"this is foo (atom)"
```

```elixir
iex(1)> {:ok, kv} = KeyValueStore3.start()
{:ok, #PID<0.112.0>}

iex(2)> Process.alive?(kv)                
true
:cleanup1 message received
:cleanup1 message received
:cleanup2 message received
:cleanup1 message received                

iex(3)> KeyValueStore3.stop(kv)
cleanup before server is terminated
:ok

iex(4)> Process.alive?(kv)     
false
```

## Chapter 6 - TodoServer with Elixir GenServer

```elixir
iex(1)> {:ok, pid} = TodoServer2.start()
{:ok, #PID<0.112.0>}

iex(2)> TodoServer2.entries(pid, ~D[2023-01-27])
[]

iex(3)> TodoServer2.add_entry(pid, %{date: ~D[2023-01-27], title: "lorem ipsum"})
:ok

iex(4)> TodoServer2.entries(pid, ~D[2023-01-27])                                 
[%{date: ~D[2023-01-27], title: "lorem ipsum"}]
```