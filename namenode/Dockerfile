FROM witlox/hadoop-spark-base
MAINTAINER Pim Witlox (pim.witlox@uzh.ch)

# Hadoop namenode
COPY debs/hadoop-hdfs-namenode_2.7.3-1_amd64.deb /tmp/hadoop-hdfs-namenode_2.7.3-1_amd64.deb
COPY debs/hadoop-hdfs-secondarynamenode_2.7.3-1_amd64.deb /tmp/hadoop-hdfs-secondarynamenode_2.7.3-1_amd64.deb
COPY debs/hadoop-mapreduce-historyserver_2.7.3-1_amd64.deb /tmp/hadoop-mapreduce-historyserver_2.7.3-1_amd64.deb
COPY debs/hadoop-yarn-proxyserver_2.7.3-1_amd64.deb /tmp/hadoop-yarn-proxyserver_2.7.3-1_amd64.deb
COPY debs/hadoop-yarn-resourcemanager_2.7.3-1_amd64.deb /tmp/hadoop-yarn-resourcemanager_2.7.3-1_amd64.deb
COPY debs/spark-history-server_2.1.0-1_all.deb /tmp/spark-history-server_2.1.0-1_all.deb

RUN dpkg -i /tmp/hadoop-hdfs-namenode_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-hdfs-secondarynamenode_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-mapreduce-historyserver_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-yarn-proxyserver_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-yarn-resourcemanager_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/spark-history-server_2.1.0-1_all.deb

# cleanup 
RUN rm -rf /tmp/*

# initialize
RUN service hadoop-hdfs-namenode start
RUN service hadoop-hdfs-secondarynamenode start
RUN service hadoop-mapreduce-historyserver start
RUN service hadoop-yarn-resourcemanager start
RUN service spark-history-server start
