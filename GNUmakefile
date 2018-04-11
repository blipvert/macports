PREFIX := /opt/local
SRCS := $(PREFIX)/etc/macports/sources.conf
SUDO := sudo
#READLINE_OPT := --enable-readline
READLINE_OPT :=

default: all

all:
	@(cd base && ([ -f Makefile ] || ./standard_configure.sh $(READLINE_OPT) --with-macports-user=$(USER) --prefix=$(PREFIX)) && $(MAKE) all)

install: all
	@(cd base && $(SUDO) $(MAKE) install)
	@if egrep -q ^rsync $(SRCS); then \
	  echo file://`pwd`/dports/ [default] >> $(SRCS); \
	  sed -i .orig -e 's/^rsync/#rsync/' $(SRCS); \
	  echo "$(SRCS) automatically configured"; \
        fi

selfupdate: install index

index:
	@mkdir -p $(HOME)/.macports$(CURDIR)/dports
	(cd dports && portindex && \
		cp PortIndex PortIndex.quick $(HOME)/.macports$(CURDIR)/dports)

clean distclean:
	@(cd base && ([ ! -f Makefile ] || $(MAKE) $@))

push:
	git push github master origin/trunk:trunk

revert:
	@(cd base && git clean -fdx && git reset --hard)

.PHONY: default all install selfupdate index clean distclean push revert
