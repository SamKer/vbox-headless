#! /bin/bash
#manipulate package


dircurrent=`dirname $0`

declare -A aHelp=()
defineHelp() {
    aHelp[$1]=$2
}

checkDir() {
 local path="$dircurrent/vbox-$1"
    if [ ! -d $path ]
    then
        echo "path package not found at: $path"
        exit 0
    else
        echo $path
    fi
}
defineHelp "build" "-v numéro de version"
_build() {
    checkParams version
    _manpage
    local package=vbox
    local version=$(getParam version)
#    local dir=$(getParam dir)
    local path=$(checkDir $version)
	echo "build package..."

	#_privileges $1 add

	#purge old build
	rm -Rf "$path/debian/vbox"
	cd $path
	debuild -us -uc
	echo "package build"
	echo ""
	#_privileges $1
}

#create manpage from vbox -h
defineHelp "manpage" "-v version package"
_manpage() {
    checkParams version
    local version=$(getParam version)
#    local dir=$(getParam dir)
    local path=$(checkDir $version)
    local sh="$path/usr/bin/vbox"
	echo "rebuild manpage..."
	shortdesc=$($sh --description)
	help2man --name="$shortdesc" "$sh" -o "$path/debian/vbox.1"
}

defineHelp "install" "-v numéro de version"
_install() {
    checkParams version
    local version=$(getParam version)

    local deb="vbox_"$version"_amd64.deb"
	if [ -f $deb ]
    then
	    echo "install deb..."
	    sudo dpkg -i $deb
	else
	    echo "no file at $deb"
    fi

    if [ -f "/usr/bin/vbox" ]
    then
        echo "install succeed"
        vbox -v
    else
        echo "install failed"
    fi
}

defineHelp "remove" "uninstall vbox"
_uninstall() {
	if [ -f "/usr/bin/vbox" ]
	then
		echo "removing vbox"
		sudo apt-get remove -y vbox --purge
	else
	    echo "vbox already removed or isn't installed"
	fi
}


_privileges() {
			if [ ! $1 ]
			then
				echo "specify project"
				exit 0
			fi
			if [ "$2" == "add" ]
			then
				echo "fix root privileges"
				sudo chown root: -R $1
				sudo chmod +x $1/debian/post*
				sudo chmod +x $1/debian/pre*
				sudo chmod 644 $1/debian/control
				sudo chmod +x $1/usr/bin/$1
				#sudo chmod +x $1/etc/init.d/vbox
			else
				echo "fix user privileges"
				sudo chown $USER: -R $1
			fi
}

#create original paquet
_create() {
echo "todo "
exit 0
	if [ ! $1 ]
	then
		echo "specify project"
		exit 0
	fi
	if [ ! $2 ]
	then
		echo "specify version"
		exit 0
	fi
	package=$1
	version=$2


	mkdir "$package-$2"
	cd "$package-$2"
	# -p package name -n native format - y auto confirm -s single package
	dh_make -p $package --createorig -n -y -s

	#replace ex extension
	for fileex in `ls debian`; do
		if [ ${fileex: -3} == ".ex" ] || [ ${fileex: -3} == ".EX" ]
		then
			extension="${fileex##*.}"
			filename="${fileex%.*}"
			mv "debian/$fileex" "debian/$filename"
		fi
	done;
	#unsupported unstable version, replace by xenial
	sed -i "s/unstable/xenial/g" debian/changelog


	#replace in control Standart version 3.9.6 by 3.9.7
	#delete readme.debian
	#field section is unknown , replace by admin for example
	#delete debian/menu
	#delete debian/manpage.sgml
	#delete debian/manpage.xml
	#create dir usr/share/doc/dir/html/index.html for manuel online
	#delete other help online in debian/project.docs.base
	#delete description in docs.base, juste keep 1 line
	#replace unknown by System for source fiel in docs.base


	echo "$1 project created"
	exit 0
}

declare -A aParams=()
defineParams() {
    aParams[script]=$0
    aParams[cmd]=$1
    shift
    while [ $# != 0 ]
    do
        case $1 in
            -h|--help)
                aParams[help]=1
            ;;
            -v)
                shift
                aParams[version]=$1
            ;;
            -n|--name)
                shift
                aParams[name]=$1
            ;;
            -d|--dir)
                shift
                aParams[dir]=$1
            ;;
        esac
        shift
    done;


}

getParam() {
    if [ ${aParams[$1]} ]
    then
        echo ${aParams[$1]}
    else
        echo 0
    fi
}

checkParams() {
    local ok=1
    while [ $# != 0 ]
    do
        if [ $(getParam $1) == "0" ]
        then
            echo "param $1 expected for command $(getParam cmd)"
            exit 0
        fi
        shift
    done
    return $ok
}



defineHelp "test" "-t|--test test quelconque"
_test() {
    echo "test OK"
}

_help() {
    for k in "${!aHelp[@]}"
    do
        echo -e "\t$k\t${aHelp[$k]}"
    done

}

defineHelp "reinstall" "re install vbox"
_reinstall() {
		_uninstall
		sleep 1
		_build
		sleep 1
		_install
}

defineParams $@

if [ $(getParam help) == 1 ]
then
    echo -e ${aHelp[$(getParam cmd)]}
    exit 0
fi

case $(getParam cmd) in
    test)
        _test
    ;;
    help|-h|--help)
        _help
    ;;
	build)
		_build
	;;
    manpage)
		_manpage
	;;
	install)
		_install
	;;
	remove|uninstall)
		_uninstall
	;;
	reinstall)
	_reinstall

	;;

	create)
		_create
	;;
	*)
		echo "no option given..."
		exit 0
	;;
esac
