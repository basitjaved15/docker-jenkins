FROM ubuntu:20.04
ARG DEBIAN_FRONTEND=noninteractive
USER root
RUN apt-get update && apt-get install -y vim nano gnupg  net-tools zsh curl sudo systemctl nginx  default-jdk zip wget telnet supervisor git elinks apt-utils 


RUN mkdir -p /var/log/supervisor

###################SonrQube Conf#####################
RUN adduser --disabled-password --shell /bin/bash --gecos "User" jenkins
RUN adduser jenkins sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
RUN sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
#RUN sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
RUN apt-get update
RUN sudo apt install -y jenkins
RUN mkdir -p /scripts
WORKDIR /scripts
RUN sudo usermod -aG sudo jenkins
COPY jenkins.sh /scripts
RUN chmod +x jenkins.sh
COPY jenkins.sh /usr/local/bin/jenkins.sh
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

################NGINX Conf#################
COPY nginx.conf /scripts/nginx.conf
COPY nginx.conf  /etc/nginx/
COPY certs /scripts/certs
COPY certs /etc/pki/tls/sonar
RUN nginx -t
################################


EXPOSE 80:80
EXPOSE 443:443
CMD ["/usr/bin/supervisord"]
#CMD ["/usr/sbin/nginx", "-g", "daemon off;"]

