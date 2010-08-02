all:
	./rebar compile

clean:
	rm -rf tests_ebin docs
	./rebar clean

test: all
	./rebar eunit
#docs: all
#	@mkdir -p docs
#	@./build_docs.sh