%% Author: github.com/jomch

-module(room).
-behaviour(gen_server).

%% API.
-export([start_link/0]).

%% gen_server.
-export([init/1]).
-export([handle_call/3]).
-export([handle_cast/2]).
-export([handle_info/2]).
-export([terminate/2]).

-record(state, {id}).

-spec start_link() -> {ok, pid()}.
start_link() ->
	gen_server:start_link( {local, room}, ?MODULE, [<<"room1">>], []). %% 第3个参数传给 init([Id]) 方法

init([Id]) ->
	{ok, #state{id = Id}}.

handle_call(_Request, _From, State) ->
	{reply, ignored, State}.

handle_cast({msg, Text}, State) ->
	ClientList = ws_store:lookup(<<"room1">>),

	%% 给Websocket进程Pid发送消息，cowboy会回调ws_handler:websocket_info方法，
	%% 所以 Msg 的格式需要匹配该方法的参数格式 websocket_info({timeout, _Ref, Msg}, State)
	send(ClientList, {timeout, self(), Text}),
	{noreply, State}.

handle_info(_Msg, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
	ok.

send([], _) ->
	ok;
send([{_, Ws} | Last], Msg) ->
	%%common:logger("room->send: "++Ws++"\r\n"),
	Pid = list_to_pid(Ws),
	Pid ! Msg, 
	send(Last, Msg).