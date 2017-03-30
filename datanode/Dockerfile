FROM witlox/hadoop-spark-base
MAINTAINER Pim Witlox (pim.witlox@uzh.ch)

# set hadoop environment
RUN $HADOOP_HOME/etc/hadoop/hadoop-env.sh

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
RUN cd $HADOOP_HOME/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

RUN service sshd start

CMD $HADOOP_HOME/sbin/start-dfs.sh
