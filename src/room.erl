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
-export([code_change/3]).

-record(state, {id}).

%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->
	gen_server:start_link( {local, room}, ?MODULE, [<<"room1">>], []).

%% gen_server.

init([Id]) ->
	{ok, #state{id = Id}}.

handle_call(_Request, _From, State) ->
	{reply, ignored, State}.

handle_cast({msg, Text}, State) ->
	ClientList = ws_store:lookup(<<"room1">>),
	send(ClientList, {msg, Text}),
	%%send(ClientList, {reply, {text, << "Server: ", Text/binary >>}, State}),
	{noreply, State}.

handle_info(_Msg, State) ->
	{noreply, State}.

terminate(_Reason, _State) ->
ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.

send([], _) ->
	ok;
send([{_, Ws} | Last], Msg) ->

	common:logger(Ws++"\r\n"),

	list_to_pid(Ws) ! Msg/binary,

	send(Last, Msg).