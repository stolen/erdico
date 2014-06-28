-module(erdico_handler).
-behavior(cowboy_http_handler).
 
-export([init/3, handle/2, terminate/3]).

init(_Type, Req, _Options) ->
    {ok, Req, nostate}.

handle(Req, nostate) ->
    {ok, Replied} = cowboy_req:reply(200, [], <<"hello\n">>, Req),
    {ok, Replied, nostate}.

terminate(_Reason, _Req, nostate) ->
    ok.
