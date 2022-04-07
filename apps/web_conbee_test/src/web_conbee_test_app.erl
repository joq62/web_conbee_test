%%%-------------------------------------------------------------------
%% @doc web_conbee_test public API
%% @end
%%%-------------------------------------------------------------------

-module(web_conbee_test_app).

-behaviour(application).

-export([start/2, stop/1]).

start(_StartType, _StartArgs) ->
    web_conbee_test_sup:start_link().

stop(_State) ->
    ok.

%% internal functions
