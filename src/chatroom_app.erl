%% Author: github.com/jomch

%% @private
-module(chatroom_app).
-behaviour(application).

%% ets table sysconfig
-define(ETS_SYSCONFIG,sysconfig).

%% API.
-export([start/2]).
-export([stop/1]).


%% API.
start(_Type, _Args) ->

	{ok,ConfigData} = file:consult("../../config/app.config"),

	Info = ets:info(?ETS_SYSCONFIG),
	case Info of
		undefined -> 
			ets:new(?ETS_SYSCONFIG,[named_table,public ,set]); %% 这里必须有分号
		_ ->
			Info %% 这里不能有分号
	end,
	lists:foreach(fun(Term)->
			%%io:format("~w~n",Term),
			ets:insert(?ETS_SYSCONFIG, Term)
			end, ConfigData),

	%% 初始化 websocket ets表
	ws_store:init(),

	%% mysql connect test
	MysqlHost = common:get_app_config(host,mysql),
	MysqlUser = common:get_app_config(user,mysql),
	MysqlPasswd = common:get_app_config(passwd,mysql),
	MysqlDB = common:get_app_config(db,mysql),
	mysql:start_link(p1, MysqlHost, MysqlUser, MysqlPasswd, MysqlDB),
	%%mysql:fetch(p1, <<"INSERT INTO t1 (id, msg) VALUES (NULL, 'from')">>),

	%% Cowboy初始化
	Dispatch = cowboy_router:compile([
		{'_', [
			{"/", cowboy_static, {priv_file, chatroom, "index.html"}},
			{"/websocket", ws_handler, []},
			{"/static/[...]", cowboy_static, {priv_dir, chatroom, "static"}}
		]}
	]),
	{ok, _} = cowboy:start_clear(http, [{port, 8088}], #{ env => #{dispatch => Dispatch} } ),
	chatroom_sup:start_link().

stop(_State) ->
	ok.
