%% Author: github.com/jomch

-module(ws_handler).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).

init(Req, Opts) ->
	{cowboy_websocket, Req, Opts}.


websocket_init(State) ->
	erlang:start_timer(1000, self(), <<"Websocket init message.">>),
	{ok, State}.


websocket_handle({text, Msg}, State) ->
	
	case Msg of

		<<"a">> ->
			{reply, {text, << "From web browser message : ", <<"aaa">>/binary >>}, State};

		<<"b">> ->
			{reply, {text, << "From web browser message : ", <<"bbb">>/binary >>}, State}
	end;



websocket_handle(_Data, State) ->
	{ok, State}.


websocket_info({timeout, _Ref, Msg}, State) ->
	erlang:start_timer(1000, self(), <<"This is server message.">>),
	{reply, {text, Msg}, State};

websocket_info(_Info, State) ->
	{ok, State}.