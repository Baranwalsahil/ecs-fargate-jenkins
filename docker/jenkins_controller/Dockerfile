FROM jenkins/jenkins:jdk17

ENV JAVA_OPTS="-Djenkins.install.runSetupWizard=false"

ARG JENKINS_USER=admin
ARG JENKINS_PASS=password

ENV JENKINS_USER=${JENKINS_USER}
ENV JENKINS_PASS=${JENKINS_PASS}
ENV TEST="TEST"

ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/jenkins.yaml


COPY plugins.txt /usr/share/jenkins/ref/
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/
COPY jenkins.yaml /usr/share/jenkins/ref/

RUN sed -i "s/JENKINS_USER/${JENKINS_USER}/g" /usr/share/jenkins/ref/jenkins.yaml
RUN sed -i "s/JENKINS_PASS/${JENKINS_PASS}/g" /usr/share/jenkins/ref/jenkins.yaml

USER 0
RUN apt update && apt upgrade
RUN  apt install wget
RUN wget https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.12.15/jenkins-plugin-manager-2.12.15.jar
# COPY jenkins-plugin-manager-2.12.15.jar /usr/local/bin/
RUN java -jar jenkins-plugin-manager-2.12.15.jar -f /usr/share/jenkins/ref/plugins.txt
