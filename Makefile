BEAM := \
Elixir.Calculator.beam \
Elixir.DatabaseServer1.beam \
Elixir.DatabaseServer2.beam \
Elixir.EchoServer.beam \
Elixir.Fraction.beam \
Elixir.KeyValueStore1.beam \
Elixir.KeyValueStore2.beam \
Elixir.KeyValueStore3.beam \
Elixir.MultiDict.beam \
Elixir.ServerProcess1.beam \
Elixir.ServerProcess2.beam \
Elixir.String.Chars.Fraction.beam \
Elixir.TodoList1.beam \
Elixir.TodoList2.beam \
Elixir.TodoList2.CsvImporter.beam \
Elixir.TodoServer.beam \
Elixir.TodoServer2.beam

.PHONY: all
all: $(BEAM)

Elixir.Calculator.beam : ch05-02-Calculator.ex
	@echo "building: $@"
	@elixirc $^

Elixir.DatabaseServer1.beam : ch05-01-DatabaseServer1.ex
	@echo "building: $@"
	@elixirc $^

Elixir.DatabaseServer2.beam : ch05-01-DatabaseServer2.ex
	@echo "building: $@"
	@elixirc $^

Elixir.EchoServer.beam : ch09-01-EchoServer.ex
	@echo "building: $@"
	@elixirc $^

Elixir.Fraction.beam : ch04-01-Fraction.ex
	@echo "building: $@"
	@elixirc $^

Elixir.KeyValueStore1.beam : ch06-02-KeyValueStore1.ex
	@echo "building: $@"
	@elixirc $^

Elixir.KeyValueStore2.beam : ch06-04-KeyValueStore2.ex
	@echo "building: $@"
	@elixirc $^

Elixir.KeyValueStore3.beam : ch06-06-KeyValueStore3.ex
	@echo "building: $@"
	@elixirc $^

Elixir.MultiDict.beam : ch04-03-MultiDict.ex
	@echo "building: $@"
	@elixirc $^

Elixir.ServerProcess1.beam : ch06-01-ServerProcess1.ex
	@echo "building: $@"
	@elixirc $^

Elixir.ServerProcess2.beam : ch06-03-ServerProcess2.ex
	@echo "building: $@"
	@elixirc $^

Elixir.String.Chars.Fraction.beam : ch04-02-Fraction-StringChars-protocol.ex
	@echo "building: $@"
	@elixirc $^

Elixir.TodoList1.beam : ch04-04-TodoList1.ex
	@echo "building: $@"
	@elixirc $^

# grouped targets
# https://www.gnu.org/software/make/manual/html_node/Multiple-Targets.html
Elixir.TodoList2.beam Elixir.TodoList2.CsvImporter.beam &: ch04-05-TodoList2.ex
	@echo "building: Elixir.TodoList2.beam"
	@echo "building: Elixir.TodoList2.CsvImporter.beam"
	@elixirc $^

Elixir.TodoServer.beam : ch06-05-TodoServer.ex
	@echo "building: $@"
	@elixirc $^

Elixir.TodoServer2.beam : ch06-07-TodoServer2.ex
	@echo "building: $@"
	@elixirc $^

.PHONY: clean
clean:
	@rm -rf *~ *.beam
