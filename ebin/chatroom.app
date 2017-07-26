{application, 'chatroom', [
	{description, "Cowboy Websocket example"},
	{vsn, "1"},
	{modules, ['chatroom_app','chatroom_sup','common','room','ws_handler','ws_store']},
	{registered, [chatroom_sup]},
	{applications, [kernel,stdlib,cowboy,mysql]},
	{mod, {chatroom_app, []}},
	{env, []}
]}.