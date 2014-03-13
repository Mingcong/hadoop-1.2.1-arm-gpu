#!/bin/bash

CMDNAME=`basename $0`
if [ $# -ne 2 ]; then
    echo "Usage: $CMDNAME input" 1>&2
    exit 1
fi

bin/hadoop dfs -rmr output

bin/hadoop pipes -D hadoop.pipes.java.recordreader=true\
 -D hadoop.pipes.java.recordwriter=true\
 -output output\
 -gpubin  bin/$1\
 -input input/$2
