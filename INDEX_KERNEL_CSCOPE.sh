#!/bin/bash

# EXCLUDE_DIRS="hello nihao"

if [ -f .cscope_exclude_dirs ]; then
    source .cscope_exclude_dirs
fi

if [ -f .cscope_suffixs ]; then
    source .cscope_suffixs
else
    source $HOME/.cscope_suffixs
fi

function gen_exclude_dirs()
{
    if [ "X$EXCLUDE_DIRS" = "X" ]; then
        return 0
    fi

    local cmd=""
    for d in $EXCLUDE_DIRS; do
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

function gen_find_cmd()
{
    local exclude_dirs=$(gen_exclude_dirs)

    if [ "X$exclude_dirs" != "X" ]; then
        cmd_part_exclude="\\( \\( $exclude_dirs \\) -prune -type f \\)"
    fi

    local suffixs_cmds=$(gen_suffixs)
    if [ "X$suffixs_cmds" = "X" ]; then
        echo "there is no suffixs!"
        exit 100
    fi
    cmd_part_suffix="\\( -type f \\( $suffixs_cmds \\) \\) "

    if [ "X$cmd_part_exclude" = "X" ]; then
        echo "find . $cmd_part_suffix"
    else
        echo "find . $cmd_part_exclude -o $cmd_part_suffix"
    fi
}

fcmd=$(gen_find_cmd)

echo $fcmd >/tmp/find_cmd_kkk.sh

bash /tmp/find_cmd_kkk.sh

# echo $fcmd >tmp.sh
# sh tmp.sh


# function gen_make_file_list()
# {
#     if [ -
# }


# find . \\( \\( -path './debian*'  -o -path './helloMe*' \\) -prune -type f \\) \
#     -o \\( -type f \\( -name '*.xml' -o -name '*.[ch]' \\) \\)



# find . \\( \\( -path './debian*'  -o -path './helloMe*' \\) -prune -type f \\) \
#     -o \\( -type f \\( -name '*.xml' \\) \\)


# find . \\( \\( -path './debian*' \\) -prune -type f \\) \
#     -o \\( -type f \\( -name '*.xml' \\) \\)


# cscope -b -i cscope.files -f cscope.out

