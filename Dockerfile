FROM openjdk:8-jre

ENV TINI_VERSION v0.19.0
ENV SPARK_VERSION=2.4.5
ENV HADOOP_VERSION=2.9.2

WORKDIR /root

ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

RUN wget https://archive.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz && \
    wget https://archive.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-without-hadoop-scala-2.12.tgz && \
    tar -xzf hadoop-${HADOOP_VERSION}.tar.gz && \
    tar -xzvf spark-${SPARK_VERSION}-bin-without-hadoop-scala-2.12.tgz && \
    rm hadoop-${HADOOP_VERSION}.tar.gz spark-${SPARK_VERSION}-bin-without-hadoop-scala-2.12.tgz && \
    mv hadoop-${HADOOP_VERSION} hadoop && mv spark-${SPARK_VERSION}-bin-without-hadoop-scala-2.12 spark && \
    wget https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-hadoop2-latest.jar && mv gcs-connector-hadoop2-latest.jar spark/jars && \
    echo export SPARK_DIST_CLASSPATH=$($HOME/hadoop/bin/hadoop classpath) | tee -a $HOME/spark/conf/spark-env.sh && chmod +x $HOME/spark/conf/spark-env.sh

COPY conf/spark-defaults.conf spark/conf/

RUN spark/bin/spark-submit spark/jars/ivy-2.4.0.jar; echo

COPY start.bash .

CMD ["bash","start.bash"]