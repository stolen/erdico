-module(erdico_counter).

-export([start_link/0, inc/0, inc/1]).

-behavior(gen_server).
-export([init/1, handle_info/2, handle_cast/2, handle_call/3, terminate/2, code_change/3]).

%% API
start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

inc() ->
    inc(1).
inc(Inc) ->
    Master = global:whereis_name(?MODULE),
    gen_server:call(Master, {inc, Inc}).

% Start: choose role
init([]) ->
    ok = global:sync(),
    {ok, capture_or_monitor()}.

% Become master or monitor existing one
capture_or_monitor() ->
    case global:register_name(?MODULE, self()) of
        yes -> {master, 0};
        no -> {slave, set_monitor()}
    end.

% Monitor master
set_monitor() ->
    Master = global:whereis_name(?MODULE),
    erlang:monitor(process, Master).


% When master goes down, try to change him
handle_info({'DOWN', Ref, process, _Master, _Info}, {slave, Ref}) ->
    {noreply, capture_or_monitor()};
% Dummy
handle_info(_, State) ->
    {noreply, State}.

% Dummy
handle_cast(_, State) ->
    {noreply, State}.

% When client asks to increment master's number, do it
handle_call({inc, Inc}, _From, {master, Count}) when is_integer(Inc) ->
    NextCount = Count + Inc,
    {reply, {ok, NextCount}, {master, NextCount}};
% Refuse to increment on slave
handle_call({inc, _}, _From, {slave, _} = State) ->
    {reply, {error, slave}, State};
% Default: return error
handle_call(_, _From, State) ->
    {reply, {error, not_implemented}, State}.

% Dummy
code_change(_, State, _) ->
    {ok, State}.

% Dummy
terminate(_, _) ->
    ok.
