IO.puts("Example #1 ------")

spawn(fn ->
  Process.flag(:trap_exit, true)
  spawn_link(fn ->
    Process.sleep(1000)
    raise("boom!")
  end)

  receive do
    msg -> IO.inspect(msg)
  end

end)

IO.puts("waiting ...")
Process.sleep(3000)
IO.puts("... done")

IO.puts("Example #2 ------")

target_pid = spawn(fn ->
  Process.sleep(2000)
  IO.puts("process done")
end)

Process.monitor(target_pid)

receive do
  msg -> IO.inspect(msg)
end
