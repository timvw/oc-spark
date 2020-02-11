FROM registry.access.redhat.com/redhat-openjdk-18/openjdk18-openshift:latest AS spark

ENV SPARK_VERSION 3.0.0-preview2
ENV HADOOP_VERSION 2.7
ENV SPARK_PACKAGE spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}
ENV SPARK_PACKAGE_URL=http://apache.belnet.be/spark/spark-${SPARK_VERSION}/${SPARK_PACKAGE}.tgz

ENV SPARK_HOME /opt/spark-${SPARK_VERSION}
ENV PATH $PATH:${SPARK_HOME}/bin

USER root

RUN mkdir -p ${SPARK_HOME} \
    && curl -sL --retry 3 "${SPARK_PACKAGE_URL}" | gunzip | tar x -C /opt/ \
    && mv /opt/$SPARK_PACKAGE/* $SPARK_HOME \
    && rm -rf /opt/$SPARK_PACKAGE \
    && chmod -R u+x ${SPARK_HOME}/bin \
    && chgrp -R 0 ${SPARK_HOME} \
    && chmod -R g=u ${SPARK_HOME} /etc/passwd

USER 10001

WORKDIR $SPARK_HOME

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "bin/spark-class", "org.apache.spark.deploy.master.Master" ]

#ENV HADOOP_CONF_DIR /etc/hadoop
#COPY ./hadoop $HADOOP_CONF_DIR
#COPY ./krb5.conf /etc/krb5.conf

FROM maven:3.6.3-jdk-8 AS javabuilder
COPY ./pom.xml /opt/pom.xml
COPY ./demo /opt/demo
WORKDIR /opt
RUN mvn clean package

FROM spark
COPY --from=javabuilder /opt/demo/target/demo-1.0-SNAPSHOT.jar /opt/spark-3.0.0-preview2/examples/jars/


