-module(erdico_log).
-export([access_log_hook/4]).

access_log_hook(Status, _Headers, _Body, Req) ->
    {{PeerAddr, _}, Req1} = cowboy_req:peer(Req),
    {Method, Req2} = cowboy_req:method(Req1),
    {Url, Req3} = cowboy_req:url(Req2),
    PeerStr = inet_parse:ntoa(PeerAddr),
    lager:info([{tag, access}, {peer, PeerStr}, {method, Method}, {url, Url}, {status, Status}], ""),
    Req3.

