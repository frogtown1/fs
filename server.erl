%% @author Benjamin McGriff, after Joe Armstrong
%% @doc    Server portion of the file server.

-module(server).
-export([start/1, loop/1]).

start(Dir) -> spawn(server, loop, [Dir]).

loop(Dir) ->
    receive
        {Client, list_dir} ->
            Client ! {self(), file:list_dir(Dir)};
        {Client, {getc_file, File}} ->
            Full = filename:join(Dir, File),
            Client ! {self(), file:read_file(Full)};
        {Client, {get_file, File}} ->
            Source      = filename:absname(File),
            Destination = filename:join(Dir, filename:basename(File)),
            Client ! {self(), file:copy(Source, Destination)};
        {Client, {putc_file, File, Binary}} ->
            Full = filename:join(Dir, File),
            Client ! {self(), file:write_file(Full, Binary)}
    end,
    loop(Dir).
