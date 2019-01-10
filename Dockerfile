FROM hseeberger/scala-sbt

ADD project/build.properties /root/project/
ADD build.sbt /root/

RUN sbt update

ADD src /root/src

RUN sbt compile
RUN sbt run
