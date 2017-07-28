%% Author: github.com/jomch

-module(ws_handler).

-behaviour(cowboy_websocket).

-export([init/2]).
-export([websocket_init/1]).
-export([websocket_handle/2]).
-export([websocket_info/2]).
%%-export([websocket_terminate/3]).

init(Req, Opts) ->
	{cowboy_websocket, Req, Opts}.

websocket_init(State) ->
	Pid = self(),
	ws_store:add(<<"room1">>, pid_to_list(Pid)),
	{ok, State}.

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

	Msg1 = re:replace(Msg, <<"&">>, <<"\\&amp;">>, [{return,binary}]),
	Msg2 = re:replace(Msg1, <<"<">>, <<"\\&lt;">>, [{return,binary}]),
	Msg3 = re:replace(Msg2, <<">">>, <<"\\&gt;">>, [{return,binary}]),

	gen_server:cast(room, {msg, Msg3}),
	{ok, State};
websocket_handle(_Data, State) ->
	{ok, State}.


websocket_info({timeout, _Ref, Msg}, State) ->
	{reply, {text, Msg}, State};
websocket_info(_Info, State) ->
	{ok, State}.

%%websocket_terminate(_Reason, _Req, _State) ->
%%	ws_store:del(<<"room1">>, self()),
%%	ok.