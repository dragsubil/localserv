localserv:
	mix deps.get
	MIX_ENV=prod mix escript.build

install: localserv
	install -m755 localserv /usr/local/bin

uninstall:
	rm -f /usr/local/bin/localserv

clean:
	rm -f localserv
	rm -rf _build
	rm -rf deps
