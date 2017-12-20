PREFIX=	/opt/local
SRCS=	${PREFIX}/etc/macports/sources.conf
SUDO=	sudo
READLINE_OPT=--enable-readline

default:: all

all::
	@(cd base && ([ -f Makefile ] || ./standard_configure.sh ${READLINE_OPT} --with-macports-user=${USER} --prefix=${PREFIX}) && ${MAKE} all)

revert::
	@(cd base && git clean -fdx && git reset --hard)

install:: all
	@(cd base && ${SUDO} ${MAKE} install)
	@if egrep -q ^rsync ${SRCS}; then \
	  echo file://`pwd`/dports/ [default] >> ${SRCS}; \
	  sed -i .orig -e 's/^rsync/#rsync/' ${SRCS}; \
	  echo "${SRCS} automatically configured"; \
        fi

selfupdate:: install index

index::
	@mkdir -p ${HOME}/.macports${CURDIR}/dports
	(cd dports && portindex && \
		cp PortIndex PortIndex.quick ${HOME}/.macports${CURDIR}/dports)

clean::
	@(cd base && ([ ! -f Makefile ] || ${MAKE} clean))

push::
	git push github master origin/trunk:trunk
