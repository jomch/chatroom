%% Author: github.com/jomch

-module(common).

-define(ETS_SYSCONFIG,sysconfig).

-export([get_app_config/2]).

-export([logger/1]).

%% Item -> mysql,redis....
get_app_config(Key,Item) when is_atom(Key) ->

	[{_,Configs}] = ets:lookup(?ETS_SYSCONFIG, Item),

	case lists:keyfind(Key, 1, Configs) of
		false ->
			[];
		{_, Val} -> 
			Val
	end;
get_app_config(_,_) -> [].

logger(Data) ->
	{ok,Fd} = file:open("../../debug.log",[write,append]),
	file:write(Fd, list_to_binary(Data)),
	file:close(Fd).