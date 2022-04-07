all:
	rm -rf  *~ */*~ apps/conbee_rel/src/*.beam test/*.beam erl_cra*;
	rm -rf  catalog host_specs deployment_specs logs *.service_dir;
	rm -rf _build test_ebin ebin;		
	mkdir ebin;		
	rebar3 compile;	
	cp _build/default/lib/*/ebin/* ebin;
	rm -rf _build test_ebin logs;
	echo Done
check:
	rebar3 check

eunit:
	rm -rf  *~ */*~ apps/conbee_rel/src/*.beam test/*.beam test_ebin erl_cra*;
	rm -rf _build logs *.service_dir;
	rm -rf  catalog host_specs deployment_specs;
	rm -rf ebin;
	rm -f rebar.lock;
	mkdir test_ebin;
	mkdir ebin;
	rebar3 compile;
	cp _build/default/lib/*/ebin/* ebin;
	erlc -o test_ebin test/*.erl;
	erl -pa .. -pa . -pa ebin -pa test_ebin -sname test -run basic_eunit start -setcookie test_cookie -config config/sys

run:
	erl -pa ebin -pa test_ebin -sname test -run basic_eunit start -setcookie test_cookie -config config/sys
release:
	rm -rf  *~ */*~  test_ebin/* erl_cra*;
	erlc -o test_ebin test/*.erl;
	erl -pa test_ebin -run release start conbee_rel ../catalog/catalog.specs
