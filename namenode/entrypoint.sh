#!/bin/bash

/bin/sh $HADOOP_HOME/etc/hadoop/hadoop-env.sh

rm -rf /tmp/*.pid

sed s/HOSTNAME/`hostname`/ $HADOOP_CONF/conf/core-site.xml.template > $HADOOP_CONF/conf/core-site.xml
sed s/HOSTNAME/`hostname`/ $HADOOP_CONF/conf/yarn-site.xml.template > $HADOOP_CONF/conf/yarn-site.xml
sed s/HOSTNAME/`hostname`/ $HADOOP_CONF/conf/mapred-site.xml.template > $HADOOP_CONF/conf/mapred-site.xml
sed s/HOSTNAME/`hostname`/ $SPARK_CONF/conf/spark-defaults.conf.template > $SPARK_CONF/conf/spark-defaults.conf

echo "Starting Resourcemanager"
/bin/sh $HADOOP_YARN_HOME/sbin/yarn-daemon.sh start resourcemanager

echo "Starting YARN History Server"
/bin/sh $HADOOP_YARN_HOME/sbin/mr-jobhistory-daemon.sh start historyserver

if [ ! -d /data/dfs/nameprimary ]; then
	echo "Formatting namenode"
	hdfs namenode -format
else
	echo "It Appears this namenode is ready. Skipping format."
fi

echo "Starting Primary Namenode"
/bin/sh $HADOOP_HOME/sbin/hadoop-daemon.sh start namenode

echo "Starting Secondary Namenode"
/bin/sh $HADOOP_HOME/sbin/hadoop-daemon.sh start secondarynamenode

exec hdfs dfs -mkdir -p /user/spark/applicationHistory

echo "Starting Spark Job History Server"
/bin/sh $SPARK_HOME/sbin/start-history-server.sh

echo "Starting Livy"
if [ -z ${HOST+x} ]; then
  export LIBPROCESS_IP=$(ip route get 8.8.8.8 | head -1 | cut -d' ' -f8)
else
  export LIBPROCESS_IP=$HOST
fi

$LIVY_HOME/bin/livy-server $@
