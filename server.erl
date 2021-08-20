%% @author Benjamin McGriff, after Joe Armstrong
%% @doc    Server portion of the file server.

-module(server).
-export([start/1, loop/1]).

start(Dir) -> spawn(server, loop, [Dir]).

loop(Dir) ->
    receive
        {Client, list_dir} ->
            Client ! {self(), file:list_dir(Dir)};
        {Client, {get_file, File}} ->
            Full = filename:join(Dir, File),
            Client ! {self(), file:read_file(Full)}
    end,
    loop(Dir).
