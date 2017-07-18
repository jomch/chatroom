PROJECT = chatroom
PROJECT_DESCRIPTION = Cowboy Websocket example
PROJECT_VERSION = 1

DEPS = cowboy mysql
dep_cowboy_commit = master

include ./libs/mk/erlang.mk
