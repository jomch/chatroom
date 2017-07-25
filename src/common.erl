-module(common).

-export([logger/1]).

logger(Data) ->
	{ok,Fd} = file:open("/data/webapps/chatroom/debug.log",[write,append]),
	file:write(Fd, list_to_binary(Data)),
	file:close(Fd).