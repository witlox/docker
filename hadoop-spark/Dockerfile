FROM phusion/baseimage
MAINTAINER Pim Witlox (pim.witlox@uzh.ch)

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Intall JAVA8 and other dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y openjdk-8-jdk wget libsnappy-dev libssl-dev openssh-server ssh rsync netcat-openbsd python

# Setup SSH
RUN mkdir -p /root/.ssh
RUN rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t ed25519 -f /etc/ssh/ssh_host_ed25519_key && \
    ssh-keygen -t rsa -P "" -f /root/.ssh/id_rsa && \
    cp /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_dsa_key
RUN cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
COPY ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config && chown root:root /root/.ssh/config

# Preliminary
COPY debs/bigtop-utils_1.2.0-1_all.deb /tmp/bigtop-utils_1.2.0-1_all.deb
COPY debs/bigtop-jsvc_1.0.15-1_amd64.deb /tmp/bigtop-jsvc_1.0.15-1_amd64.deb
COPY debs/bigtop-groovy_2.4.4-1_all.deb /tmp/bigtop-groovy_2.4.4-1_all.deb
COPY debs/zookeeper_3.4.6-1_all.deb /tmp/zookeeper_3.4.6-1_all.deb

RUN dpkg -i /tmp/bigtop-utils_1.2.0-1_all.deb
RUN dpkg -i /tmp/bigtop-jsvc_1.0.15-1_amd64.deb
RUN dpkg -i /tmp/bigtop-groovy_2.4.4-1_all.deb
RUN dpkg -i /tmp/zookeeper_3.4.6-1_all.deb

# Hadoop
COPY debs/hadoop_2.7.3-1_amd64.deb /tmp/hadoop_2.7.3-1_amd64.deb
COPY debs/hadoop-hdfs_2.7.3-1_amd64.deb /tmp/hadoop-hdfs_2.7.3-1_amd64.deb
COPY debs/hadoop-yarn_2.7.3-1_amd64.deb /tmp/hadoop-yarn_2.7.3-1_amd64.deb
COPY debs/hadoop-mapreduce_2.7.3-1_amd64.deb /tmp/hadoop-mapreduce_2.7.3-1_amd64.deb
COPY debs/hadoop-client_2.7.3-1_amd64.deb /tmp/hadoop-client_2.7.3-1_amd64.deb

RUN dpkg -i /tmp/hadoop_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-hdfs_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-yarn_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-mapreduce_2.7.3-1_amd64.deb
RUN dpkg -i /tmp/hadoop-client_2.7.3-1_amd64.deb

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
ENV HADOOP_CONF_DIR	/etc/hadoop
ENV HADOOP_OPTS		-Djava.library.path=/usr/lib/hadoop/lib/native
ENV SCALA_HOME 		/usr/local/scala
ENV SBT_HOME 		/usr/local/sbt
ENV SPARK_HOME 		/usr/lib/spark
ENV SPARK_CONF		/etc/spark
ENV SPARK_VERSION 	2.1.0
ENV PATH		$PATH:$JAVA_HOME/bin:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$SCALA_HOME/bin:$SBT_HOME/bin:$SPARK_HOME/bin:$SPARK_HOME/sbin

# Persist environment variables
RUN echo "export JAVA_HOME="$JAVA_HOME >> /etc/environment
RUN echo "export HADOOP_HOME="$HADOOP_HOME >> /etc/environment
RUN echo "export HADOOP_YARN_HOME="$HADOOP_YARN_HOME >> /etc/environment
RUN echo "export HADOOP_CONF="$HADOOP_CONF >> /etc/environment
RUN echo "export HADOOP_CONF_DIR="$HADOOP_CONF >> /etc/environment
RUN echo "export HADOOP_OPTS="$HADOOP_OPTS >> /etc/environment
RUN echo "export SCALA_HOME="$SCALA_HOME >> /etc/environment
RUN echo "export SBT_HOME="$SBT_HOME >> /etc/environment
RUN echo "export SPARK_HOME="$SPARK_HOME >> /etc/environment
RUN echo "export SPARK_CONF="$SPARK_CONF >> /etc/environment
RUN echo "export SPARK_VERSION="$SPARK_VERSION >> /etc/environment

# cleanup
RUN apt-get clean && apt-get purge && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

# Overwrite default configuration files with our config files
COPY capacity-scheduler.xml $HADOOP_CONF/conf/capacity-scheduler.xml
COPY core-site.xml $HADOOP_CONF/conf/core-site.xml.template
COPY hdfs-site.xml $HADOOP_CONF/conf/hdfs-site.xml
COPY mapred-site.xml $HADOOP_CONF/conf/mapred-site.xml.template
COPY yarn-site.xml $HADOOP_CONF/conf/yarn-site.xml.template

# Configure Spark
RUN cp $SPARK_HOME/conf/log4j.properties.template $SPARK_CONF/conf/log4j.properties
RUN cp $SPARK_HOME/conf/metrics.properties.template $SPARK_CONF/conf/metrics.properties
RUN sed -i -e s/WARN/ERROR/g $SPARK_CONF/conf/log4j.properties && sed -i -e s/INFO/ERROR/g $SPARK_CONF/conf/log4j.properties
COPY spark-defaults.conf $SPARK_CONF/conf/spark-defaults.conf.template

# Shuffle service
RUN cp $SPARK_HOME/yarn/*.jar $HADOOP_YARN_HOME/lib/

# HDFS ports
EXPOSE 50010 50020 50070 50075 50090

# YARN ports
EXPOSE 8030 8031 8032 8033 8040 8042 8088

# Magic other ports
EXPOSE 49707 2122 

# Spark ports
EXPOSE 4040 8080 8081 18080

ONBUILD CMD ["hdfs"]
