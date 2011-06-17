#!/bin/sh
################################################################
# file: Ebuild.sh
# author: Richard Luo
# date: 2010/04/18 11:15:55
################################################################

function Gettop
{
    local TOPFILE=build/core/envsetup.mk
    if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
        echo $TOP
    else
        if [ -f $TOPFILE ] ; then
            echo $PWD
        else
            # We redirect cd to /dev/null in case it's aliased to
            # a command that prints something as a side-effect
            # (like pushd)
            local HERE=$PWD
            T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                cd .. > /dev/null
                T=$PWD
            done
            cd $HERE > /dev/null
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}

function Croot()
{
    T=$(Gettop)
    if [ "$T" ]; then
        cd $(Gettop)
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
    fi
}



function Bmm()
{
    T=$(Gettop)
    if [ "$T" ]; then
        cd $(Gettop)/build
        source envsetup.sh
        cd -
        mm $1
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
    fi
}

Bmm $1