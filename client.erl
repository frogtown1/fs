%% @author Benjamin McGriff, after Joe Armstrong.
%% @doc    Client API module to access the file server. Also hides
%%         underlying details of the comms protocol.

-module(client).
-export([ls/1, getc_file/2, get_file/2, putc_file/2]).

ls(Server) ->
    Server ! {self(), list_dir},
    receive
        {Server, FileList} ->
            FileList;
        {Server, {error, Reason}} ->
            Reason
    end.

% Read contents of File.
getc_file(Server, File) ->
    Server ! {self(), {getc_file, File}},
    receive
        {Server, Content} ->
            Content;
        {Server, {error, Reason}} ->
            Reason
    end.

% Get copy of a file to place in Server directory.
get_file(Server, File) ->
    Server ! {self(), {get_file, File}},
    receive
        {Server, Status} ->
            Status;
        {Server, {error, Reason}} ->
            Reason
    end.

% Write content to File.
putc_file(Server, File) ->
    {ok, Binary} = file:read_file(File),
    Server ! {self(), {putc_file, File, Binary}},
    receive
        {Server, ok} ->
            ls(Server);
        {Server, {error, Reason}} ->
            Reason
    end.
