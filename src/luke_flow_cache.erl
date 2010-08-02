-module(luke_flow_cache).

-behaviour(gen_server).

%% API
-export([start_link/0,
         cache_value/3,
         check_cache/2,
         delete_value/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-record(state, {cache=dict:new()}).

start_link() ->
    gen_server:start_link(?MODULE, [], []).

cache_value(Pid, Key, Value) ->
    gen_server:call(Pid, {cache_value, Key, Value}).

check_cache(Pid, Key) ->
    gen_server:call(Pid, {check_cache, Key}).

delete_value(Pid, Key) ->
    gen_server:call(Pid, {delete_value, Key}).

init([]) ->
    {ok, #state{}}.

handle_call({cache_value, Key, Value}, _From, #state{cache=Cache0}=State) ->
    Cache = dict:store(Key, Value, Cache0),
    {reply, ok, State#state{cache=Cache}};
handle_call({check_cache, Key}, _From, #state{cache=Cache}=State) ->
    Reply = case dict:is_key(Key, Cache) of
                false ->
                    not_found;
                true ->
                    dict:fetch(Key, Cache)
            end,
    {reply, Reply, State};
handle_call({delete_value, Key}, _From, #state{cache=Cache0}=State) ->
    Cache = dict:erase(Key, Cache0),
    {reply, ok, State#state{cache=Cache}};
handle_call(_Request, _From, State) ->
    {reply, ignore, State}.

handle_cast(_Msg, State) ->
    {noreply, State}.

handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

code_change(_OldVsn, State, _Extra) ->
    {ok, State}.
