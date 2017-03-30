FROM phusion/baseimage
MAINTAINER Pim Witlox (pim.witlox@uzh.ch)

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Intall JAVA8 and other dependencies
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-8-jdk wget libsnappy-dev libssl-dev openssh-server ssh rsync

# Hadoop
COPY debs/hadoop_2.7.3-1_amd64.deb /tmp/hadoop_2.7.3-1_amd64.deb
COPY debs/hadoop-client_2.7.3-1_amd64.deb /tmp/hadoop-client_2.7.3-1_amd64.deb
COPY debs/hadoop-hdfs_2.7.3-1_amd64.deb /tmp/hadoop-hdfs_2.7.3-1_amd64.deb
COPY debs/hadoop-hdfs-fuse_2.7.3-1_amd64.deb /tmp/hadoop-hdfs-fuse_2.7.3-1_amd64.deb
COPY debs/hadoop-mapreduce_2.7.3-1_amd64.deb /tmp/hadoop-mapreduce_2.7.3-1_amd64.deb
COPY debs/hadoop-yarn_2.7.3-1_amd64.deb /tmp/hadoop-yarn_2.7.3-1_amd64.deb

RUN dpkg -i /tmp/hadoop_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-client_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-hdfs_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-hdfs-fuse_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-mapreduce_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-yarn_2.7.3-1_amd64.deb

# Scala
ARG SCALA_VERSION=2.12.1
ARG SCALA_BINARY_ARCHIVE_NAME=scala-${SCALA_VERSION}
ARG SCALA_BINARY_DOWNLOAD_URL=http://downloads.lightbend.com/scala/${SCALA_VERSION}/${SCALA_BINARY_ARCHIVE_NAME}.tgz
RUN wget -qO - ${SCALA_BINARY_DOWNLOAD_URL} | tar -xz -C /usr/local/ && ln -s /usr/local/${SCALA_BINARY_ARCHIVE_NAME} $SCALA_HOME

# SBT
ARG SBT_VERSION=0.13.13
ARG SBT_BINARY_ARCHIVE_NAME=sbt-$SBT_VERSION
ARG SBT_BINARY_DOWNLOAD_URL=https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/${SBT_BINARY_ARCHIVE_NAME}.tgz
RUN wget -qO - ${SBT_BINARY_DOWNLOAD_URL} | tar -xz -C /usr/local/ && ln -s /usr/local/${SBT_BINARY_ARCHIVE_NAME} $SBT_HOME

# Spark
COPY debs/spark-core_2.1.0-1_all.deb /tmp/spark-core_2.1.0-1_all.deb
COPY debs/spark-thriftserver_2.1.0-1_all.deb /tmp/spark-thriftserver_2.1.0-1_all.deb
COPY debs/spark-python_2.1.0-1_all.deb /tmp/spark-python_2.1.0-1_all.deb
COPY debs/spark-yarn-shuffle_2.1.0-1_all.deb /tmp/spark-yarn-shuffle_2.1.0-1_all.deb
COPY debs/spark-external_2.1.0-1_all.deb /tmp/spark-external_2.1.0-1_all.deb

RUN dpkg -i /tmp/spark-core_2.1.0-1_all.deb
RUN dpkg -i /tmp/spark-thriftserver_2.1.0-1_all.deb
RUN dpkg -i /tmp/spark-python_2.1.0-1_all.deb
RUN dpkg -i /tmp/spark-yarn-shuffle_2.1.0-1_all.deb
RUN dpkg -i /tmp/spark-external_2.1.0-1_all.deb

# Set environment variables
ENV JAVA_HOME		/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV HADOOP_HOME		/usr/lib/hadoop
ENV HADOOP_YARN_HOME	/usr/lib/hadoop-yarn
ENV HADOOP_CONF		/etc/hadoop
ENV HADOOP_OPTS		-Djava.library.path=/usr/lib/hadoop/lib/native
ENV SCALA_HOME 		/usr/local/scala
ENV SBT_HOME 		/usr/local/sbt
ENV SPARK_HOME 		/usr/lib/spark
ENV SPARK_CONF		/etc/spark
ENV PATH		$PATH:JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SCALA_HOME/bin:$SBT_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin

# cleanup
RUN apt-get remove -y wget
RUN apt-get clean
RUN apt-get purge
RUN rm -rf /tmp/*
RUN rm -rf /var/lib/apt/lists/*

# Overwrite default configuration files with our config files
COPY capacity-scheduler.xml $HADOOP_CONF/conf/capacity-scheduler.xml
COPY core-site.xml $HADOOP_CONF/conf/core-site.xml
COPY hdfs-site.xml $HADOOP_CONF/conf/hdfs-site.xml
COPY mapred-site.xml $HADOOP_CONF/conf/mapred-site.xml
COPY yarn-site.xml $HADOOP_CONF/conf/yarn-site.xml
# Rewrite host-name
sed s/hostname/$HOSTNAME/ $HADOOP_CONF/conf/core-site.xml > $HADOOP_CONF/conf/core-site.xml

# Configure Spark
RUN cp $SPARK_HOME/conf/log4j.properties.template $SPARK_CONF/conf/log4j.properties
RUN cp $SPARK_HOME/conf/metrics.properties.template $SPARK_CONF/conf/metrics.properties
RUN sed -i -e s/WARN/ERROR/g $SPARK_CONF/conf/log4j.properties && sed -i -e s/INFO/ERROR/g $SPARK_CONF/conf/log4j.properties
COPY spark-defaults.conf $SPARK_CONF/conf/spark-defaults.conf

# Shuffle service
RUN cp $SPARK_HOME/yarn/*.jar $HADOOP_YARN_HOME/lib/

# Format HDFS
RUN mkdir -p /data/dfs/data /data/dfs/name /data/dfs/namesecondary
RUN hdfs namenode -format

# Mount point for Data
VOLUME /data

# HDFS ports
EXPOSE 50010 50020 50070 50075 50090

# YARN ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088

# Magic other ports
EXPOSE 49707 2122 

# Spark ports
EXPOSE 4040 8080 8081 18080

ONBUILD CMD ["hdfs"]
