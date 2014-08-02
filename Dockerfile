FROM meoooh/ubuntu14.04
MAINTAINER hgk617@naver.com

RUN apt-get install -qq -y software-properties-common pwgen

RUN apt-key adv --recv-keys --keyserver hkp://keyserver.ubuntu.com:80 0xcbcb082a1bb943db

RUN add-apt-repository -y 'deb http://ftp.kaist.ac.kr/mariadb/repo/10.0/ubuntu trusty main'

RUN apt-get install -qq -y mariadb-server

RUN sed -i 's/^\(bind-address\s.*\)/# \1/' /etc/mysql/my.cnf

ADD create_account.sh /create_account.sh

RUN chmod +x /*.sh

CMD ./create_account.sh

EXPOSE 3306
