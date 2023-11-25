#!/bin/bash

PROJECT_ROOT=$1
SERVER_COUNT=$2
USE_MAKEFILE=$3

if [ -z "$PROJECT_ROOT" ]; then
    echo "Project root path is required"
    exit 1
fi

if [ -z "$SERVER_COUNT" ]; then
    echo "Server count is required"
    exit 1
fi

mkdir -p $PROJECT_ROOT

if [ "$USE_MAKEFILE" = "-m" ] ; then
    cp ./files/Makefile $PROJECT_ROOT/Makefile
fi

for ((i=1; i<=$SERVER_COUNT; i++)) do 
    mkdir -p $PROJECT_ROOT/s$i
    
    mkdir -p $PROJECT_ROOT/s$i/etc
    mkdir -p $PROJECT_ROOT/s$i/etc/nginx $PROJECT_ROOT/s$i/etc/mysql $PROJECT_ROOT/s$i/etc/systemd $PROJECT_ROOT/s$i/etc/systemd/system
    
    touch $PROJECT_ROOT/s$i/etc/nginx/.gitkeep
    touch $PROJECT_ROOT/s$i/etc/mysql/.gitkeep
    touch $PROJECT_ROOT/s$i/etc/systemd/system/.gitkeep
done
