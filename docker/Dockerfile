FROM amazonlinux:2
USER root

RUN yum update -y 
RUN yum install -y aws-cli gawk initscripts
ADD bootstrap.sh /tmp/
ADD sap-setup.txt /tmp/

RUN chmod +x /tmp/bootstrap.sh 
RUN bash /tmp/bootstrap.sh --params_file /tmp/sap-setup.txt > /tmp/bootstrap.log

# expose server port
EXPOSE 9002
