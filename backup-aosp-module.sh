function gettop
{
    local TOPFILE=build/make/core/envsetup.mk
    if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
        # The following circumlocution ensures we remove symlinks from TOP.
        (cd $TOP; PWD= /bin/pwd)
    else
        if [ -f $TOPFILE ] ; then
            # The following circumlocution (repeated below as well) ensures
            # that we record the true directory name and not one that is
            # faked up with symlink names.
            PWD= /bin/pwd
        else
            local HERE=$PWD
            local T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                \cd ..
                T=`PWD= /bin/pwd -P`
            done
            \cd $HERE
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}

function backup_module {
    if [ -n "$1" -a -d "$1" ] ; then
        local T=$(gettop)
        local relative_path=$(realpath --relative-to=$T "$1")
        # echo "relative_path: $relative_path"
        local backup_name="${relative_path//\//.}"
        # echo "backup_name: $backup_name"
        if [ ! -d "$BACKUP_TOP/$backup_name" ] ; then
            if mv $1 "$BACKUP_TOP/$backup_name" ; then
                echo "OK: moved $relative_path to $BACKUP_TOP/$backup_name"
            else
                echo "Failed to mv $relative_path $BACKUP_TOP/$backup_name"
                exit -1
            fi
        else
            echo "Conflict: $BACKUP_TOP/$backup_name exist!"
            exit -1
        fi
    else
        echo "please input valid module dir"
        exit -1
    fi
}

export BACKUP_TOP='/home/richard/aosp-sources/backup-local'

for arg in "$@"
do
    backup_module $arg
done
