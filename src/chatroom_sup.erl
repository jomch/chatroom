%% Author: github.com/jomch

%% @private
-module(chatroom_sup).
-behaviour(supervisor).

%% API.
-export([start_link/0]).

%% supervisor.
-export([init/1]).

%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->

	{ok,Pid} = supervisor:start_link({local, ?MODULE}, ?MODULE, []),

	common:logger("chatroom_sup pid: "++pid_to_list(Pid)++"\r\n"),

	{ok,Pid}.

%% supervisor.

init([]) ->

	%% Procs = [],
	Procs = [{room, {room, start_link, []}, permanent, 2000, worker, [room]}], %% 启动room子进程

	{ok, {{one_for_one, 10, 10}, Procs}}.
