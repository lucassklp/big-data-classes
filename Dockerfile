FROM ubuntu:22.04

#Install Java, Scala and wget
RUN apt-get update && \
    apt-get install -y software-properties-common && \
    apt install -y openjdk-8-jdk && \
    apt install -y openjdk-8-jre && \
    apt-get install -y scala && \
    apt-get install -y wget && \
    apt-get install -y ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java

# Install python
RUN add-apt-repository -y ppa:deadsnakes/ppa && \
    apt install -y python3.9 && \
    apt-get install -y python3-pip


# Change user to docker
RUN adduser --system docker
USER docker
ENV PATH "$PATH:/home/docker/.local/bin"

# Install jupyter, py4j and pyspark
RUN pip3 install jupyter && \
    pip3 install py4j && \
    pip3 install pyspark

# Install Spark
WORKDIR /software
RUN wget https://downloads.apache.org/spark/spark-3.2.1/spark-3.2.1-bin-hadoop3.2.tgz
RUN tar xvf spark-*

WORKDIR /work
EXPOSE 8888

RUN export SPARK_HOME=/software/spark-3.2.1-bin-hadoop3.2/
RUN export PATH=$PATH:$SPARK_HOME/bin:$SPARK_HOME/sbin
RUN export PYSPARK_PYTHON=/usr/bin/python3
RUN export PYSPARK_DRIVER_PYTHON="jupyter"
RUN export PYSPARK_DRIVER_PYTHON_OPTS="notebook"

ENTRYPOINT [ "jupyter", "notebook", "--ip",  "0.0.0.0"]