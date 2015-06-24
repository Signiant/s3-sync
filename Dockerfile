FROM signiant/docker-awscli

MAINTAINER Signiant DevOps <devops@signiant.com>

ADD s3_sync.sh /s3_sync.sh
ADD paths.dat /paths.dat

RUN chmod a+x /s3_sync.sh

ENTRYPOINT ["/s3_sync.sh"]
