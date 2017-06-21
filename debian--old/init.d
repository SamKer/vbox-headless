#!/bin/sh
# kFreeBSD do not accept scripts as interpreters, using #!/bin/sh and sourcing.
if [ true != "$INIT_D_SCRIPT_SOURCED" ] ; then
    set "$0" "$@"; INIT_D_SCRIPT_SOURCED=true . /lib/init/init-d-script
fi

### BEGIN INIT INFO
# Provides:          vbox
# Required-Start:    vboxdrv $local_fs $remote_fs $syslog
# Required-Stop:     vboxdrv $local_fs $remote_fs $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: <Enter a short description of the software>
# Description:       <Enter a long description of the software>
#                    <...>
#                    <...>
### END INIT INFO

# Author: samir.keriou <samir.keriou@gmail.com>

DESC="vbox"
DAEMON=/usr/bin/vbox


start() {
echo "starting"
}
stop() {
echo "stop"
}

restart() {
echo "restart"
}

status () {
echo "status"
}

case $1 in
	start|stop|status)
		${1}
	;;
	restart|force-reload|reload)
		stop
		sleep 30
		start
	;;
esac

exit 0

