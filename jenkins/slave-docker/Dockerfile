FROM centos:latest
MAINTAINER steven_xiao <workdsz@163.com>
USER root
RUN yum -y install wget sudo java-1.8.0-openjdk git ca-certificates curl netbase gnupg dirmngr bzr mercurial openssh-client procps 
#获取jnlp
RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/3.9/remoting-3.9.jar \
	&& chmod 755 /usr/share/jenkins \
	&& chmod 644 /usr/share/jenkins/slave.jar
RUN curl --create-dirs -sSLo /usr/local/bin/jenkins-slave https://raw.githubusercontent.com/jenkinsci/docker-jnlp-slave/3.27-1/jenkins-slave \
	&& chmod a+x /usr/local/bin/jenkins-slave
# 创建jenkins与system用户
RUN useradd --system --shell /bin/bash --create-home --home /home/jenkins jenkins
RUN echo "jenkins ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/jenkins
#安装maven包
ADD apache-maven-3.6.1-bin.tar.gz /usr/local/ 
RUN cd /usr/local && mv apache-maven-3.6.1 maven
#加nexus的配置文件到maven中
COPY settings.xml /usr/local/maven/conf/
#加kubect到jlnp中，以便调用kubernetes
COPY kubectl /usr/bin/kubectl
#输出自己定义的环境
ENV MAVEN_HOME /usr/local/maven
RUN mkdir -p /home/jenkins/.jenkins
VOLUME /home/jenkins/.jenkins
WORKDIR /home/jenkins
ENTRYPOINT ["jenkins-slave"]mgih 