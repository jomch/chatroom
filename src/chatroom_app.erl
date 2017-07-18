%% Feel free to use, reuse and abuse the code in this file.

%% @private
-module(chatroom_app).
-behaviour(application).

%% API.
-export([start/2]).
-export([stop/1]).

%% API.
start(_Type, _Args) ->
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
