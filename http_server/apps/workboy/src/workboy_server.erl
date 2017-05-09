%% gen_server代码模板

-module(workboy_server).

-behaviour(gen_server).
% --------------------------------------------------------------------
% Include files
% --------------------------------------------------------------------

% --------------------------------------------------------------------
% External exports
% --------------------------------------------------------------------
-export([]).

% gen_server callbacks
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

-record(state, {}).

% --------------------------------------------------------------------
% External API
% --------------------------------------------------------------------
-export([do_work/2, do_work/3]).


do_work(Pid, Work) ->
    gen_server:cast(Pid, {work, Work}).

do_work(Pid, Key, Work) ->
    gen_server:cast(Pid, {work, Work, Key}).


% start_link() ->
%     gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

start_link() ->
    gen_server:start_link(?MODULE, [], []).


% --------------------------------------------------------------------
% Function: init/1
% Description: Initiates the server
% Returns: {ok, State}          |
%          {ok, State, Timeout} |
%          ignore               |
%          {stop, Reason}
% --------------------------------------------------------------------
init([]) ->
    {ok, #state{}}.

% --------------------------------------------------------------------
% Function: handle_call/3
% Description: Handling call messages
% Returns: {reply, Reply, State}          |
%          {reply, Reply, State, Timeout} |
%          {noreply, State}               |
%          {noreply, State, Timeout}      |
%          {stop, Reason, Reply, State}   | (terminate/2 is called)
%          {stop, Reason, State}            (terminate/2 is called)
% --------------------------------------------------------------------
handle_call(_Request, _From, State) ->
    Reply = ok,
    {reply, Reply, State}.

% --------------------------------------------------------------------
% Function: handle_cast/2
% Description: Handling cast messages
% Returns: {noreply, State}          |
%          {noreply, State, Timeout} |
%          {stop, Reason, State}            (terminate/2 is called)
% --------------------------------------------------------------------
handle_cast({work, {fetch_web, From}}, State) ->
    Url = "https://www.baidu.com/",
    % case httpc:request(Url) of
    % case httpc:request(get, {Url, []}, [], []) of
    List = lists:seq(1,1000),
    lists:foreach(fun(X)->
        timer:sleep(10),
        case httpc:request(get, {Url, []},
                            [{autoredirect, true}, {timeout, 60000}, {version, "HTTP/1.1"}],
                            [{body_format, binary}]) of
            {ok, {_,_, _Body}}->
                From ! {from_workboy, "fetch success : " ++ Url ++ to_str(X)},
                ok;
            {error, Reason} ->
                From ! {from_workboy, "fetch failed !!!: " ++ Url},
                io:format("error cause ~p~n",[Reason])
        end
    end,List),

    From ! {from_workboy, "fetch done !!!"},

    table_work:delete(fetch_web),

    {stop, normal, State};
handle_cast({work, {read_mysql, From}}, State) ->
    io:format("do work here ~n"),
    % do work here
    % Pid ! {from_workboy, <<"from workboy Message">>},

    List = lists:seq(1,1000),
    lists:foreach(fun(X)->
        timer:sleep(10),
        From ! {from_workboy, "from workboy Message: "++ to_str(X)}
    end,List),

    table_work:delete(read_mysql),

    {stop, normal, State};
handle_cast(_Msg, State) ->
    {noreply, State}.

% --------------------------------------------------------------------
% Function: handle_info/2
% Description: Handling all non call/cast messages
% Returns: {noreply, State}          |
%          {noreply, State, Timeout} |
%          {stop, Reason, State}            (terminate/2 is called)
% --------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

% --------------------------------------------------------------------
% Function: terminate/2
% Description: Shutdown the server
% Returns: any (ignored by gen_server)
% --------------------------------------------------------------------
terminate(_Reason, _State) ->
    ok.

% --------------------------------------------------------------------
% Func: code_change/3
% Purpose: Convert process state when code is changed
% Returns: {ok, NewState}
% --------------------------------------------------------------------
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.


% private functions

to_str(X) when is_list(X) -> X;
to_str(X) when is_atom(X) -> atom_to_list(X);
to_str(X) when is_binary(X) -> binary_to_list(X);
to_str(X) when is_integer(X) -> integer_to_list(X);
to_str(X) when is_float(X) -> float_to_list(X).
