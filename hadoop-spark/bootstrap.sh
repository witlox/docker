#!/bin/bash

$HADOOP_HOME/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd $HADOOP_HOME/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

service sshd start

if [[ $1 = "-namenode" || $2 = "-namenode" ]]; then
  $HADOOP_HOME/sbin/start-dfs.sh
  $HADOOP_HOME/sbin/start-yarn.sh
  $SPARK_HOME/sbin/start-history-server.sh
fi

if [[ $1 = "-datanode" || $2 = "-datanode" ]]; then
  $HADOOP_HOME/sbin/start-dfs.sh
fi

if [[ $1 = "-d" || $2 = "-d" ]]; then
  while true; do sleep 1000; done
fi

if [[ $1 = "-bash" || $2 = "-bash" ]]; then
  /bin/bash
fi
