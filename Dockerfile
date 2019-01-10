FROM amazonlinux:2017.03

ENV SCALA_VERSION 2.12.6
ENV SBT_VERSION 1.2.1

# Install Java8
RUN yum install -y java-1.8.0-openjdk-devel

# Install Scala and SBT
RUN yum install -y https://downloads.lightbend.com/scala/2.12.6/scala-2.12.6.rpm
RUN yum install -y https://dl.bintray.com/sbt/rpm/sbt-1.2.1.rpm

# Uncomment bellow to fix the recompilation issue
# https://github.com/sbt/sbt/issues/4168#issuecomment-417655678
# ENV SBT_OPTS="${SBT_OPTS} -Dsbt.io.jdktimestamps=true"

RUN mkdir /app
WorkDIR /app

ADD project/build.properties /app/project/
ADD build.sbt /app/

RUN sbt -batch update

ADD src /app/src

RUN sbt -batch compile
RUN sbt -batch run
