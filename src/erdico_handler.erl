-module(erdico_handler).
-behavior(cowboy_http_handler).
 
-export([init/3, handle/2, terminate/3]).

init(_Type, Req, user_inc) ->
    {ok, Req, user_inc};
init(_Type, Req, []) ->
    {ok, Req, nostate}.

handle(Req, nostate) ->
    {ok, CounterValue} = erdico_counter:inc(),
    ResponseBody = <<"value = ", (integer_to_binary(CounterValue))/binary, "\n">>,
    {ok, Replied} = cowboy_req:reply(200, [], ResponseBody, Req),
    {ok, Replied, nostate};

handle(Req0, user_inc) ->
    {AmountBin, Req} = cowboy_req:binding(amount, Req0),
    {ok, CounterValue} = erdico_counter:inc(binary_to_integer(AmountBin)),
    ResponseBody = <<"value = ", (integer_to_binary(CounterValue))/binary, "\n">>,
    {ok, Replied} = cowboy_req:reply(200, [], ResponseBody, Req),
    {ok, Replied, nostate}.

terminate(_Reason, _Req, nostate) ->
    ok.
