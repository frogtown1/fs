%% @author Benjamin McGriff, after Joe Armstrong.
%% @doc    Client API module to access the file server. Also hides
%%         underlying details of the comms protocol.

-module(client).
-export([ls/1, get_file/2]).

ls(Server) ->
    Server ! {self(), list_dir},
    receive
        {Server, FileList} ->
            FileList
    end.

get_file(Server, File) ->
    Server ! {self(), {get_file, File}},
    receive
        {Server, Content} ->
            Content
    end.
