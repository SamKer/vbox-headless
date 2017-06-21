#!/bin/sh
# kFreeBSD do not accept scripts as interpreters, using #!/bin/sh and sourcing.

### BEGIN INIT INFO
# Provides:          vbox
# Required-Start:    $local_fs $remote_fs $syslog
# Required-Stop:     $local_fs $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: tools for vboxmanage
# Description:       manage vms via vboxmanage
### END INIT INFO

# Author: samir.keriou <samir.keriou@gmail.com>
. /lib/lsb/init-functions
DESC="vbox"
DAEMON=/usr/bin/vbox


start() {
	$DAEMON start --enable
}
stop() {
	$DAEMON stop
}

status () {
	$DAEMON status
}

case $1 in
	start|stop|status)
		${1}
	;;
	restart|force-reload|reload)
		stop
		echo "waiting before start"
		sleep 60
		start
	;;
esac

exit 0
