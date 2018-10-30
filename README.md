# chatroom v1.0

Erlang cowboy & Websocket 实现的聊天室


初始化 erlang.mk
```
cd /libs/mk
wget https://raw.githubusercontent.com/ninenines/erlang.mk/master/erlang.mk
make -f erlang.mk bootstrap bootstrap-rel
```

编译和启动
```
cd /
make run
```

在没有域名和证书的情况下，可以采用ws连接方式，注释掉chatroom_app.erl中相关代码即可。



