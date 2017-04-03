FROM witlox/hadoop-spark-base
MAINTAINER Pim Witlox (pim.witlox@uzh.ch)

# Reset path
ENV PATH $PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SCALA_HOME/bin:$SBT_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Livy dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y maven r-base r-base-dev

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

# Cleanup 
RUN rm -rf /tmp/*

# Create hdfs dirs on local filesystem
RUN mkdir -p /data/dfs/data
RUN mkdir -p /data/dfs/nameprimary
RUN mkdir -p /data/dfs/namesecondary

# Mark hadoop root as volume
VOLUME /data/dfs

# Livy
ENV LIVY_PATH /usr/lib/livy

ARG LIVY_VERSION=0.3.0
ARG LIVY_BINARY_ARCHIVE_NAME=livy-server-${LIVY_VERSION}
ARG LIVY_BINARY_DOWNLOAD_URL=http://archive.cloudera.com/beta/livy/${LIVY_BINARY_ARCHIVE_NAME}.zip
RUN wget -qO- -O tmp.zip ${LIVY_BINARY_DOWNLOAD_URL} && unzip tmp.zip && mv ${LIVY_BINARY_ARCHIVE_NAME} /usr/lib/${LIVY_BINARY_ARCHIVE_NAME} && rm tmp.zip && ln -s /usr/local/${LIVY_BINARY_ARCHIVE_NAME} $LIVY_PATH

# configure livy
COPY livy-defaults.conf $LIVY_PATH/conf/livy-defaults.conf

RUN echo "export LIVY_HOME="$LIVY_PATH >> /etc/environment

# add startup script
ADD entrypoint.sh /etc/entrypoint.sh
RUN chmod +x /etc/entrypoint.sh

# Livy port
EXPOSE 8998

CMD ["/etc/entrypoint.sh"]
