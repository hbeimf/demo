%%%-------------------------------------------------------------------
%% @doc tcp_server public API
%% @end
%%%-------------------------------------------------------------------

-module(tcp_server_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%%====================================================================
%% API
%%====================================================================

start(_Type, _Args) ->
    {ok, _} = ranch:start_listener(tcp_server, 10,
        ranch_tcp, [{port, 5555}], server_protocol, []),
    tcp_server_sup:start_link().



%%--------------------------------------------------------------------
stop(_State) ->
    ok.

%%====================================================================
%% Internal functions
%%====================================================================


