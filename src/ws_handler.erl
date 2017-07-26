%% Author: github.com/jomch

-module(ws_handler).

-behaviour(cowboy_websocket).

-export([init/2]).
-export([websocket_init/3]).
-export([websocket_handle/2]).
-export([websocket_info/2]).
%%-export([websocket_terminate/3]).

init(Req, Opts) ->
	{cowboy_websocket, Req, Opts}.

%% old code
%%websocket_init(State) ->
%%	Pid = self(),
%%	common:logger("ws_handler pid: "++pid_to_list(Pid)++"\r\n"),
%%	erlang:start_timer(1000, Pid, <<"Welcome to Chatroom">> ),
%%	{ok, State}.

websocket_init(_TransportName, Req, _Opts) ->
	ws_store:add(<<"room1">>, self()),
	{ok, Req, undefined_state}.


%% old code
%%websocket_handle({text, Msg}, State) ->
%%	case Msg of
%%		<<"aa">> ->
%%			{reply, {text, << "Server: ", <<"Hello,aa">>/binary >>}, State};
%%		<<"bb">> ->
%%			{reply, {text, << "Server: ", <<"Hello,aa">>/binary >>}, State};
%%		_ ->
%%			{reply, {text, << "Server: ", Msg/binary >>}, State}	
%%	end;
%%websocket_handle(_Data, State) ->
%%	{ok, State}.

websocket_handle({text, Msg}, State) ->
	gen_server:cast(room, {msg, Msg}),
	{ok, State};
websocket_handle(_Data, State) ->
	{ok, State}.

%% old code
%%websocket_info({timeout, _Ref, Msg}, State) ->
%%	%%erlang:start_timer(1000, self(), <<"This is server message.">>),
%%	{reply, {text, Msg}, State};
%%websocket_info(_Info, State) ->
%%	{ok, State}.

websocket_info({timeout, _Ref, Msg}, State) ->
	{reply, {text, Msg}, State};
websocket_info(_Info, State) ->
	{ok, State}.

%%websocket_terminate(_Reason, _Req, _State) ->
%%	ws_store:del(<<"room1">>, self()),
%%	ok.