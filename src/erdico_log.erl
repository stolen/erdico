-module(erdico_log).
-export([access_log_hook/4]).

access_log_hook(Status, Headers, Body, Req) ->
    {[{PeerAddr, _}, Method, Url], Req2} = lists:mapfoldl(fun get_req_prop/2, Req, [peer, method, url]),
    {ok, ReqReplied} = cowboy_req:reply(Status, Headers, Body, Req2),
    PeerStr = inet_parse:ntoa(PeerAddr),
    lager:info([{tag, access}, {peer, PeerStr}, {method, Method}, {url, Url}, {status, Status}], ""),
    ReqReplied.

get_req_prop(Prop, Req) ->
        cowboy_req:Prop(Req).
