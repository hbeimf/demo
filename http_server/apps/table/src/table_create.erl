-module(table_create).
-compile(export_all).

-include_lib("stdlib/include/qlc.hrl").
%% 定义记录结构

-include("table.hrl").

start() ->
    mnesia:start(),
    %% 等待表的加载
    TableList = table_list(),
    % mnesia:wait_for_tables([scene],20000).
    mnesia:wait_for_tables(TableList, 20000).


%% 初始化mnesia表结构
init() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(scene, [{attributes,record_info(fields,scene)}]), %% 创建shop表
    mnesia:create_table(work, [{attributes,record_info(fields,work)}]), %% 创建work表

    % TableList = table_list(),

    % lists:foreach(fun(Table) ->
    %     io:format("table:================ ~p ~p ~n", [Table, record_info(fields, Table)])
    %     % mnesia:create_table(Table, [{attributes, record_info(fields, Table)}])

    % end, TableList),

    ok.
    % mnesia:stop().


table_list() ->
    [scene, work].
