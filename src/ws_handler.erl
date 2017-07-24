%% Author: github.com/jomch

-module(ws_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, Opts) ->
	{cowboy_websocket, Req, Opts}.


websocket_init(State) ->

	%%Pid = self(),
	%%{ok,F} = file:open("/data/webapps/chatroom/debug.log",write).

	%%code:add_patha("/data/webapps/chatroom/ebin"),
	%%common:logger("abc\r\n"),

	erlang:start_timer(1000, self(), <<"Welcome to englishzone.cn">> ),
	{ok, State}.


websocket_handle({text, Msg}, State) ->
	
	case Msg of

		<<"aa">> ->
			{reply, {text, << "Server response: ", <<"Hello,aa">>/binary >>}, State};

		<<"bb">> ->
			{reply, {text, << "Server response: ", <<"Hello,aa">>/binary >>}, State};

		_ ->
			{reply, {text, << "Server response: ", Msg/binary >>}, State}
			
	end;

websocket_handle(_Data, State) ->
	{ok, State}.


%%websocket_info({timeout, _Ref, Msg}, State) ->
%%	erlang:start_timer(1000, self(), <<"This is server message.">>),
%%	{reply, {text, Msg}, State};

websocket_info(_Info, State) ->
	{ok, State}.