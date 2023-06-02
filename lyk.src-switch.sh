#! /bin/bash


case "$1" in
    del)
	    echo -n "Delete unused: "
        find . -type l -exec rm -f {} \;
        rm -rf lyk.del
	    ;;
    back)
	    echo -n "Back to original: "
        tar zxf lyk.del.tgz
        ln -fs lyk.del/* .
	    ;;
esac

exit 0
