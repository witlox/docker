FROM ubuntu:16.04
MAINTAINER Pim Witlox (pim.witlox@uzh.ch)

# Intall JAVA8
RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-8-jdk wget libsnappy-dev libssl-dev openssh-server

# Hadoop
ARG HADOOP_VERSION=2.7.3
ARG HADOOP_BINARY_ARCHIVE_NAME=hadoop-${HADOOP_VERSION}
ARG HADOOP_BINARY_DOWNLOAD_URL=http://archive.apache.org/dist/hadoop/core/hadoop-${HADOOP_VERSION}/${HADOOP_BINARY_ARCHIVE_NAME}.tar.gz

# Scala
ARG SCALA_VERSION=2.12.1
ARG SCALA_BINARY_ARCHIVE_NAME=scala-${SCALA_VERSION}
ARG SCALA_BINARY_DOWNLOAD_URL=http://downloads.lightbend.com/scala/${SCALA_VERSION}/${SCALA_BINARY_ARCHIVE_NAME}.tgz

# SBT
ARG SBT_VERSION=0.13.13
ARG SBT_BINARY_ARCHIVE_NAME=sbt-$SBT_VERSION
ARG SBT_BINARY_DOWNLOAD_URL=https://dl.bintray.com/sbt/native-packages/sbt/${SBT_VERSION}/${SBT_BINARY_ARCHIVE_NAME}.tgz

# Spark
ARG SPARK_VERSION=2.1.0
ARG SPARK_BINARY_ARCHIVE_NAME=spark-${SPARK_VERSION}-bin-hadoop2.7
ARG SPARK_BINARY_DOWNLOAD_URL=http://d3kbcqa49mib13.cloudfront.net/${SPARK_BINARY_ARCHIVE_NAME}.tgz

# Set environment variables
ENV JAVA_HOME		/usr/lib/jvm/java-1.8.0-openjdk-amd64
ENV HADOOP_HOME		/usr/lib/hadoop
ENV HADOOP_CONF		$HADOOP_HOME/etc/hadoop
ENV HADOOP_OPTS		-Djava.library.path=/usr/lib/hadoop/lib/native
ENV SCALA_HOME 		/usr/local/scala
ENV SBT_HOME 		/usr/local/sbt
ENV SPARK_HOME 		/usr/lib/spark
ENV PATH		$PATH:JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SCALA_HOME/bin:$SBT_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Download and install our components
RUN wget -qO - ${HADOOP_BINARY_DOWNLOAD_URL} | tar -xz -C /usr/lib/ && ln -s /usr/lib/${HADOOP_BINARY_ARCHIVE_NAME} $HADOOP_HOME
RUN wget -qO - ${SCALA_BINARY_DOWNLOAD_URL} | tar -xz -C /usr/local/ && ln -s /usr/local/${SCALA_BINARY_ARCHIVE_NAME} $SCALA_HOME
RUN wget -qO - ${SBT_BINARY_DOWNLOAD_URL} | tar -xz -C /usr/local/ && ln -s /usr/local/${SBT_BINARY_ARCHIVE_NAME} $SBT_HOME
RUN wget -qO - ${SPARK_BINARY_DOWNLOAD_URL} | tar -xz -C/usr/lib/ && ln -s /usr/lib/${SPARK_BINARY_ARCHIVE_NAME} $SPARK_HOME

# cleanup
RUN apt-get remove -y wget
RUN apt-get clean
RUN apt-get purge
RUN rm -rf /tmp/*
RUN rm -rf /var/lib/apt/lists/*

# Overwrite default configuration files with our config files
COPY capacity-scheduler.xml $HADOOP_CONF/capacity-scheduler.xml
COPY core-site.xml $HADOOP_CONF/core-site.xml
COPY hdfs-site.xml $HADOOP_CONF/hdfs-site.xml
COPY mapred-site.xml $HADOOP_CONF/mapred-site.xml
COPY yarn-site.xml $HADOOP_CONF/yarn-site.xml

# Configure Spark
RUN cp $SPARK_HOME/conf/log4j.properties.template $SPARK_HOME/conf/log4j.properties
RUN sed -i -e s/WARN/ERROR/g $SPARK_HOME/conf/log4j.properties && sed -i -e s/INFO/ERROR/g $SPARK_HOME/conf/log4j.properties
COPY spark-defaults.conf $SPARK_HOME/conf/spark-defaults.conf

# Shuffle service
RUN cp $SPARK_HOME/yarn/*.jar $HADOOP_HOME/lib/

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

