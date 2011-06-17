#!/bin/sh
################################################################
# genfs.sh
# Richard Luo
# 2009-01-20
# $1: specify file system type {jffs2|cramfs|ext2|...}
# $2: specify root dir of the file system
# $3: the output fs image name 
# $4: the function of the fs {rootfs|appsfs|...}
################################################################


# $1: input root dir
# $2: type: rootfs, or appfs
# $3: output image file name
make_cramfs()
{
    local USERNAME=`whoami`
    local MKCRAMFS=`which mkcramfs`

    if [ -z $1 ]; then
        echo "shoud input your root path"
        return 99
    fi

    if [ -z ${MKCRAMFS} ]; then
        echo "Error, there is no command tool: mkcramfs, please install it first!!!"
        return 97
    fi

    if [ ! -d $1 ]; then
        echo "$1 doesn't exit!"
        return 99
    fi

    local rootdir=$1

    case "$2" in
        rootfs)
            sudo bash scripts/make_device_node.sh $rootdir/dev \
                && sudo mkdir -p $rootdir/dev/mqueue \
	            && sudo $MKCRAMFS $rootdir $3 \
                && sudo chown -R $USERNAME:$USERNAME $3 $rootdir
            ;;
        appsfs)
	        $MKCRAMFS $rootdir $3
            ;;
        *)
            ;;
    esac

    return 0
}

make_fs_tmpdir() 
{

    if [ ! -d $1 ] ; then
        echo "$1 is not a dir"
        exit 100
    fi

    if sudo rm -rf  $1.tmp && sudo cp -rfd $1 $1.tmp; then
        echo "make new $1.tmp ok"
    else
        echo "failed to make new $1.tmp"
        exit 100
    fi

    sudo chown -R richard.richard $1.tmp

    # if find $1.tmp -name ".svn" -print | xargs rm -rf; then
    #     echo "rm *.svn ok"
    # else
    #     echo "failed to rm .svn"
    #     exit 100
    # fi

    # case "$2" in
    #     rootfs)
    #         sh ./addlibs.sh $2
    #         (cd $1.tmp/lib && ln -fs /tmp/udev .)
    #         ;;
    #     appsfs)
    #         sh ./addlibs.sh $2
    #         ;;
    # esac

    return 0
}


# $1: input root dir
# $2: type: rootfs, or appfs
# $3: output image file name
make_ext2()
{
    local USERNAME=`whoami`
    local MKCRAMFS=`which mkcramfs`

    if [ -z $1 ]; then
        echo "shoud input your root path"
        return 99
    fi

    if [ ! -d $1 ]; then
        echo "$1 doesn't exit!"
        return 99
    fi

    # if dd if=/dev/zero of=$3 bs=1024 count=4096 \
    #     && echo "y" > /tmp/yy \
    #     && mkfs.ext2 $3 < /tmp/yy; then
    #     echo "dd passed"
    # else
    #     echo "failed with dd!"
    # fi

    if dd if=/dev/zero of=$3 bs=1024 count=6000 \
        && echo "y" > /tmp/yy \
        && mkfs.ext2 $3 < /tmp/yy; then
        echo "dd passed"
    else
        echo "failed with dd!"
    fi

    local rootdir=root.ext2.tmp

    sudo rm -rf $rootdir
    mkdir $rootdir
    sudo mount -t ext2 -o loop $3 $rootdir

    sudo cp -a $1/* $rootdir/

    # case "$2" in
    #     rootfs)
    #         sudo bash scripts/make_device_node.sh $rootdir/dev \
    #             && sudo chown -R $USERNAME:$USERNAME $3 $rootdir/
    #         ;;
    # esac
 
    sudo umount $rootdir

    return 0
}



# $1: fs type: cramfs jffs2 ext2
# $2: root dir, not we would make a copy of this dir, so it would not have any change after this execute
# $3: output image name
# $4: rootfs or appsfs
main()
{
    case "$1" in

        jffs2)
            pagesize=4096
            erase_blk_size=128
            mkfs.jffs2 -l -s ${pagesize} -e ${erase_blk_size} -r $2.tmp -o $3
            ;;

        cramfs)
            make_cramfs $2.tmp $4 $3
            ;;

        ext2)
            make_ext2 $2.tmp $4 $3
            ;;

        *)
            exit 100
	        ;;

    esac
}

make_fs_tmpdir $2 $4

main $1 $2 $3 $4 $5
