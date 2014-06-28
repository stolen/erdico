-module(erdico).
% For erl -s erdico
-export([start/0]).

% Application here
-behavior(application).
-export([start/2, stop/1]).

% Supervisor is also here
-behavior(supervisor).
-export([init/1]).

start() ->
    application:ensure_all_started(?MODULE).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Application callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start(_, _) ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, root).

stop(_) ->
    ok.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Supervisor callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
init(root) ->
    {ok, _} = start_cowboy(),
    Counter = {counter, {erdico_counter, start_link, []},
               permanent, 1000, worker, [erdico_counter]},
    {ok, {{one_for_one, 10, 5}, [Counter]}}.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Internals
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
start_cowboy() ->
    DefPath = {'_', erdico_handler, []},    % Catch-all path
    Host = {'_', [DefPath]},                % No virtualhosts
    Dispatch = cowboy_router:compile([Host]),
    Env = [{env, [{dispatch, Dispatch}]}],
    cowboy:start_http(?MODULE, 10, [{port, conf(port, 2080)}], Env).

conf(Key, Default) ->
    application:get_env(?MODULE, Key, Default).
