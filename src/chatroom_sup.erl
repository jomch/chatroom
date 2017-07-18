%% Feel free to use, reuse and abuse the code in this file.

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
	supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% supervisor.

init([]) ->

	%% mysql connect test
	mysql:start_link(p1, "localhost", "root", "123456", "test"),
	mysql:fetch(p1, <<"INSERT INTO t1 (id, msg) VALUES (NULL, 'from')">>),

	Procs = [],
	{ok, {{one_for_one, 10, 10}, Procs}}.
