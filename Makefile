all:
	./rebar compile

clean:
	rm -rf tests_ebin docs
	./rebar clean

test: all
	./rebar eunit

docs: 
	./rebar doc
