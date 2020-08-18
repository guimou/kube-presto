FROM egaillardon/jmeter:5.2.1-1.0.0

# Variables that define which software versions to install.
ENV JMETER_VERSION 5.2.1
ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV PRESTO_VER=338
ENV JAVA_HOME=/usr/lib/jvm/java-1.8-openjdk

RUN curl -o $JMETER_HOME/lib/presto-jdbc-$PRESTO_VER.jar https://repo1.maven.org/maven2/io/prestosql/presto-jdbc/$PRESTO_VER/presto-jdbc-$PRESTO_VER.jar

WORKDIR /opt

COPY jmeter-bench.sh jmeter-tpcds.jmx ./
