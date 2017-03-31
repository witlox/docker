FROM witlox/hadoop-spark-base
MAINTAINER Pim Witlox (pim.witlox@uzh.ch)

# Rewrite host-name
RUN sed s/hostname/$HOSTNAME/ $HADOOP_CONF/conf/core-site.xml > $HADOOP_CONF/conf/core-site.xml

# Hadoop datanode
COPY debs/hadoop-hdfs-datanode_2.7.3-1_amd64.deb /tmp/hadoop-hdfs-datanode_2.7.3-1_amd64.deb
COPY debs/hadoop-yarn-nodemanager_2.7.3-1_amd64.deb /tmp/hadoop-yarn-nodemanager_2.7.3-1_amd64.deb

RUN dpkg -i /tmp/hadoop-hdfs-datanode_2.7.3-1_amd64.deb
RUN dpkg -i /tmphadoop-yarn-nodemanager_2.7.3-1_amd64.deb

# cleanup 
RUN rm -rf /tmp/*

# initialize
RUN service hadoop-hdfs-datanode start
RUN service hadoop-yarn-nodemanager start
