# Code for Elixir in Action

My companion code for book [Elixir in Action (Second Edition)](https://www.manning.com/books/elixir-in-action-second-edition) by Saša Jurić.

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