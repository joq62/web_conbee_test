%%%-------------------------------------------------------------------
%% @doc lgh_rel public API
%% @end
%%%-------------------------------------------------------------------

-module(lgh_init).

-define(Port,6809). % Change also Port and Path in index.htlm"
-define(Handler,lgh_handler).
-define(NoRouteHandler,no_matching_route_handler).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
  
    Port=?Port,
    
    {ok,Cwd}=file:get_cwd(),
    io:format("Cwd :~p~n",[Cwd]),
    code:add_patha("priv"),
    PathToFile=code:where_is_file("index.html"),
    io:format("PathToFile :~p~n",[PathToFile]),
    FullPath=filename:join(Cwd,PathToFile),
 %   FullPath="index.html",
    io:format("FullPath :~p~n",[FullPath]),
    timer:sleep(1000),
    io:format("Port :~p~n",[Port]),

    ssl:start(),
    application:start(crypto),
    application:start(ranch), 
    application:start(cowlib), 
    application:start(cowboy), 

    HelloRoute = { "/", cowboy_static, {file,FullPath} },
    WebSocketRoute = {"/please_upgrade_to_websocket", ?Handler, []},
    CatchallRoute = {"/[...]", ?NoRouteHandler, []},

    Dispatch = cowboy_router:compile([
				      {'_',
				       [HelloRoute, 
					WebSocketRoute, 
					CatchallRoute
				       ]
				      }
				     ]),
    {ok, _} = cowboy:start_clear(http, [{port, Port}], #{
							 env => #{dispatch => Dispatch}
							}),
    ok.

stop(_State) ->
    ok.

%% internal functions
