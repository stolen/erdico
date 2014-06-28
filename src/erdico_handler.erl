-module(erdico_handler).
-behavior(cowboy_http_handler).
 
-export([init/3, handle/2, terminate/3]).

init(_Type, Req, _Options) ->
    {ok, Req, nostate}.

handle(Req, nostate) ->
    {ok, CounterValue} = erdico_counter:inc(),
    ResponseBody = <<"value = ", (integer_to_binary(CounterValue))/binary, "\n">>,
    {ok, Replied} = cowboy_req:reply(200, [], ResponseBody, Req),
    {ok, Replied, nostate}.

terminate(_Reason, _Req, nostate) ->
    ok.
