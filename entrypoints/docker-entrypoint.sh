#!/bin/sh

set -e

# to create mysql container volume
DIR="/tmp/docker_mysql_v/mysqld/"
if [ ! -d "$DIR" ]; then
    # Take action if $DIR not exists. #
    mkdir -p $DIR  && chmod -R 777 $DIR
    # mkdir -p /tmp/docker_mysql_v/mysqld && chmod -R 777 /tmp/docker_mysql_v/mysqld
fi

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

bundle exec rails s -b 0.0.0.0