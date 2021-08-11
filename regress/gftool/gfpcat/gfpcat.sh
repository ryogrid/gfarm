#!/bin/sh

set -eu

. ./regress.conf

BASEDIR=`dirname $0`
. ${BASEDIR}/setup_gfpcat.sh

setup_test

test_write_to_gfarm_j1()
{
    # with -t
    $GFPCAT -t -j 1 -o $gfile_out $gfile2 $lfile2 $gfile1 file:$lfile1
}

test_write_to_local()
{
    $GFPCAT -o $lfile_out $lfile1 file:$lfile2 $gfile1 $gfile2
}

test_write_to_gfarm()
{
    $GFPCAT -o $gfile_out $gfile2 $gfile1 $lfile2 file:$lfile1
}

test_write_to_local_0byte()
{
    $GFPCAT -o $lfile_out $gfile_zero $lfile_zero
}

test_write_to_gfarm_0byte()
{
    $GFPCAT -o $gfile_out $gfile_zero $lfile_zero
}

test_same_locale_file()
{
    if $GFPCAT -o file:$lfile1 $lfile1 2> /dev/null; then
        exit $exit_fail
    else
        true
    fi
}

test_same_gfarm_file()
{
    if $GFPCAT -o $gfile1 $gfile1 2> /dev/null; then
        exit $exit_fail
    else
        true
    fi
}

test_write_to_gfarm_j1
test_write_to_local
test_write_to_gfarm
test_write_to_local_0byte
test_write_to_gfarm_0byte
test_same_locale_file
test_same_gfarm_file

clean_test
exit $exit_pass
