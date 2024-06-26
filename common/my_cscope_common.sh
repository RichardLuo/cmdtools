#!/bin/bash
################################################################
# file: my_cscope_common.sh
# author: Richard Luo
# date: 2011/01/19 08:12:05
################################################################

# $1: values to append
function EXCLUDE_DIRS_add()
{
    if [ "X$1" = "X" ]; then
        return 1
    fi
    eval "EXCLUDE_DIRS=\"$EXCLUDE_DIRS $1\""
}

function import_one_file()
{
    if [ -z $1 ]; then
        echo "please specify the bash file!"
        return 1
    fi
    
    if [ -f $1 ]; then
        source $1
        echo "imported $1"
        return 0
    fi

    return 1
}

################################################################
# there are two kinds of config files:
#  1. common to all
#  2. module specific
# Note: the module specific config files may overwite the common
# config files
################################################################
function import_cscope_config()
{
    local path_module=$1
    local path_common=$HOME/bin/common
    local common_exclude_dirs=$path_common/exclude_dirs
    local common_suffixs=$path_common/suffixs

    if [ "X$path_module" = "X" ]; then
        path_module=$PWD
    fi

    import_one_file $common_exclude_dirs
    import_one_file $path_module/.cscope_exclude_dirs

    import_one_file $common_suffixs
    import_one_file $path_module/.cscope_suffixs
}

function gen_exclude_dirs_from_config_file() {
    local dirs=""
    if [ -f ".emcgrep-exclude-dirs" ] ; then
        local lines=$(cat ".emcgrep-exclude-dirs")
        for d in $lines; do
            dirs="$d $dirs"
        done
    fi
    echo "$dirs"
}    

function gen_exclude_dirs()
{
    local EXCLUDE_DIRS=$(gen_exclude_dirs_from_config_file)

    if [ "X$EXCLUDE_DIRS" = "X" ]; then
        return 0
    fi

    local cmd=""
    for d in $EXCLUDE_DIRS; do
#        d=`basename $d`
#        d=`realpath $d`
        d=`echo $d | perl -pe 's/[^\w]*(.*\w+)[^\w]*/$1/'`
#        echo "d:$d" >&2 && exit 9 
        if [ "X$cmd" != "X" ]; then
            cmd="$cmd -o -path './$d'"
        else
            cmd="-path './$d'"
        fi
    done
    echo "$cmd"
}

# gen_exclude_dirs

# SUFFIXS="c xml"

function gen_suffixs()
{
    if [ "X$SUFFIXS" = "X" ]; then
        return 0
    fi

    local cmd=""
    for s in $SUFFIXS; do
        if [ "X$cmd" != "X" ]; then
            cmd="$cmd -o -name '*.$s'"
        else
            cmd="-name '*.$s'"
        fi
    done
    echo "$cmd"
}

# gen_suffixs

function gen_filenames()
{
    if [ "X$BASENAMES" = "X" ]; then
        return 0
    fi

    local cmd=""
    for s in $BASENAMES; do
        if [ "X$cmd" != "X" ]; then
            cmd="$cmd -o -name '$s'"
        else
            cmd="-name '$s'"
        fi
    done
    echo "$cmd"
}

function gen_find_cmd()
{
    local result=""
    local exclude_dirs=$(gen_exclude_dirs)

#    echo "exclude_dirs: $exclude_dirs" >&2
    if [ "X$exclude_dirs" != "X" ]; then
        cmd_part_exclude="\\( \\( $exclude_dirs \\) -prune -type f \\)"
        result="$cmd_part_exclude"
    fi

    local suffixs_cmds=$(gen_suffixs)
    if [ "X$suffixs_cmds" != "X" ]; then
        cmd_part_suffix="\\( -type f \\( $suffixs_cmds \\) \\) "
        if [ "X$result" != "X" ]; then
            result="$result -o $cmd_part_suffix"
        else
            result="$cmd_part_suffix"
        fi
    fi

    local filenames_cmds=$(gen_filenames)
    if [ "X$filenames_cmds" != "X" ]; then
        cmd_part_names="\\( -type f \\( $filenames_cmds \\) \\) "
        if [ "X$result" != "X" ]; then
            result="$result -o $cmd_part_names"
        else
            result="$cmd_part_names"
        fi
    fi

    result="find . "$result

    if [ -f .cscope_grep.sh ]; then
        local grep_cmd=`cat .cscope_grep.sh`
        result=$result" | "$grep_cmd
    fi
    # echo $result >&2
    # exit 9
    echo $result
}

function gen_find_cmd_4emcgrep()
{
    local result=""
    local exclude_dirs=$(gen_exclude_dirs)

#    echo "exclude_dirs: $exclude_dirs" >&2
    if [ "X$exclude_dirs" != "X" ]; then
        cmd_part_exclude="\\( \\( $exclude_dirs \\) -prune -type f \\)"
        result="$cmd_part_exclude"
    fi

    local suffixs_cmds=$(gen_suffixs)
    if [ "X$suffixs_cmds" != "X" ]; then
        cmd_part_suffix="\\( -type f \\( $suffixs_cmds \\) \\) "
        if [ "X$result" != "X" ]; then
            result="$result -o $cmd_part_suffix"
        else
            result="$cmd_part_suffix"
        fi
    fi

    local filenames_cmds=$(gen_filenames)
    if [ "X$filenames_cmds" != "X" ]; then
        cmd_part_names="\\( -type f \\( $filenames_cmds \\) \\) "
        if [ "X$result" != "X" ]; then
            result="$result -o $cmd_part_names"
        else
            result="$cmd_part_names"
        fi
    fi

    result="find . "$result

    # echo $result >&2
    # exit 9
    echo $result
}




function gen_file_list()
{
    local fcmd=$(gen_find_cmd)
    local tmp_sh=/tmp/fixme_workaround_cmd.sh
    echo $fcmd>$tmp_sh

    # fixme_workaround_cmd.bat | sed  -e '/\/tsrc\//d' -e '/\/build_arm\//d' -e '/\/opensrc\//d' \
    #     -e '/upnp.sample\//d' -e '/\/lyk.del\//d'  -e '/\/.*lyk.bak\//d' -e '/\/CVS\//d' -e '/\/RCS\//d' -e 's/^\.\///' | \
    #     sort > cscope.files

    echo "generating the list file..."
    bash $tmp_sh>cscope.files
}


function is_linux_kernel()
{
    if [ -d net  -a -d ipc -a -d mm -a -d sound -a -d Documentation -a -d drivers -a -d arch -a -d kernel -a -d fs ]; then
        return 0
    fi
    return 1
}

function is_in_android_platform()
{
    local TOPFILE=build/core/envsetup.mk
    if [ -f "$TOP/$TOPFILE" ] ; then
        return 0
    fi

    T=
    local HERE=$PWD
    while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
        cd .. > /dev/null
        T=$PWD
    done
    cd $HERE > /dev/null
    if [ -f "$T/$TOPFILE" ]; then
        return 0
    fi

    return 1
}
