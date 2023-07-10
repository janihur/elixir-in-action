# Chapter 10 - ETS Tables

Create project:
```
$ mix new key_value --module KeyValue
```

Benchmark:
```
$ mix run -e 'Bench.run(KeyValue)'
Compiling 1 file (.ex)
Generated key_value app

447434 operations/sec
```

```
$ mix run -e 'Bench.run(KeyValue, concurrency: 1000)'

568362 operations/sec
```

```
$ mix run -e 'Bench.run(EtsKeyValue)'
Compiling 1 file (.ex)
Generated key_value app

3055249 operations/sec
```

```
$ mix run -e 'Bench.run(EtsKeyValue, concurrency: 1000, num_updates: 100)'

5965794 operations/sec
```
