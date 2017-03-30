#!/bin/bash

if [ "$1" == scratch ]; then
  docker rmi -f hdfs-namenode hdfs-datanode
fi
docker build -t hdfs-namenode .
docker build -t hdfs-datanode .

