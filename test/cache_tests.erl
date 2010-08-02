-module(cache_tests).

-include_lib("eunit/include/eunit.hrl").

read_write_test_() ->
    [fun() ->
             {ok, Pid} = luke_flow_cache:start_link(),
             Key = "hello",
             Value = "world",
             luke_flow_cache:cache_value(Pid, Key, Value),
             ?assertMatch(Value, luke_flow_cache:check_cache(Pid, Key)),
             ?assertMatch(not_found, luke_flow_cache:check_cache(Pid, "world")),
             luke_flow_cache:delete_value(Pid, Key),
             ?assertMatch(not_found, luke_flow_cache:check_cache(Pid, Key)) end].
