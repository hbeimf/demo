%%%-------------------------------------------------------------------
%% @doc mysql public API
%% @end
%%%-------------------------------------------------------------------

-module(demo).
-compile(export_all).
% -export([start/1, start/2]).

% demo() ->
%     Years = lists:seq(2000,this_year()),
%     lists:foldl(fun(Y, Res) ->
%         [year(Y)|Res]
%     end, [], Years).
    % ok.

years() ->
    Years = lists:seq(2000,this_year()),
    lists:foldl(fun(Y, Res) ->
        lists:merge(year(Y),Res)
    end, [], Years).


today() ->
    ThisYear = this_year(),
    {ThisYear, lists:max(get_quarter_list(ThisYear))}.

year(Year) ->
    % io:format("Y:~p ~p ~n", [Year, get_quarter_list(Year)]),
    lists:foldl(fun(Jd, Res) ->
        [{Year, Jd}|Res]
    end, [], get_quarter_list(Year)).

this_year() ->
    {{ThisYear, _ThisMonth, _},_} = lib_fun:timestamp_to_datetime(lib_fun:time()),
    ThisYear.

this_month() ->
    {{_, ThisMonth, _},_} = lib_fun:timestamp_to_datetime(lib_fun:time()),
    ThisMonth.

get_quarter_list(Year) ->
    ThisYear = this_year(),
    Quarter = case Year =:= ThisYear of
        true ->
            get_quarter(this_month());
        _ ->
            get_quarter(12)
    end,
    lists:seq(1, Quarter).

% 获取季度
get_quarter(Month) when Month =< 3 ->
    1;
get_quarter(Month) when Month =< 6 ->
    2;
get_quarter(Month) when Month =< 9 ->
    3;
get_quarter(_Month) ->
    4.

