FROM ubuntu:22.04
CMD printf ES_HOST=; read ES_HOST
CMD /opt/arkime/db/db.pl http://${ES_HOST}:9200 init
WORKDIR /opt
RUN mkdir arkime
ENV ARKIME_SRC=https://github.com/arkime/arkime/releases/download/v4.6.0/arkime_4.6.0-1.ubuntu2204_amd64.deb
ENV JAVA_HOME=usr/lib/jvm/java-11-openjdk-amd64/
ENV ES_JAVA_HOME=usr/lib/jvm/java-11-openjdk-amd64/
ENV ADMIN_USERNAME='admin'
ENV ADMIN_PASS='arkime'
RUN apt-get -y update
RUN apt-get -y install curl default-jre gettext
RUN curl -fsSL $ARKIME_SRC -O
RUN apt-get -y install './arkime_4.6.0-1.ubuntu2204_amd64.deb'
COPY ./etc /opt/arkime/etc
COPY ./updateConf.sh /
RUN  /updateConf.sh
RUN /opt/arkime/bin/arkime_add_user.sh admin $ADMIN_USERNAME $ADMIN_PASS --admin
