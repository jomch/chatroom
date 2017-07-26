-module(ws_store).
-define(WS_TABLE, chatroom_ws_store).

%% API
-export([init/0,add/2, del/2, lookup/1]).

init() ->
  ets:new(?WS_TABLE, [public, bag, named_table]).

add(Room, Ws) ->
  ets:insert(?WS_TABLE, {Room, Ws}).

del(Room, Ws) ->
  ets:delete(?WS_TABLE, {Room, Ws}).

lookup(Room) ->
  ets:lookup(?WS_TABLE, Room).