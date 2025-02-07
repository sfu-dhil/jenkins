# Docker file for the DHIL's Jenkins (experimental)
# This is mostly derived from the TEI's, but modified for
# our needs


FROM jenkins/jenkins:lts-jdk21
ARG NODE_MAJOR=22
ARG SAXON_MAJOR=12
ARG SAXON_MINOR=4
ARG SAXON_VERSION=SaxonHE${SAXON_MAJOR}-${SAXON_MINOR}
ARG SAXON_URL=https://github.com/Saxonica/Saxon-HE/releases/download/${SAXON_VERSION}/${SAXON_VERSION}J.zip
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

USER root

# ca-certificates because curl uses certificates from ca-certificates
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl gnupg lsb-release && \
    # Installing nodejs
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install nodejs -y && apt-get clean && rm -rf /var/lib/apt/lists/* 

RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

# RUN apt-get update && apt-get -y --no-install-recommends --no-install-suggests install \
#     ant \
#     ant-optional \
#     ant-contrib \
#     debhelper \
#     jing \
#     imagemagick \
#     libjing-java \ 
#     libsaxon-java \ 
#     libsaxonhe-java \
#     libxml2-utils \ 
#     libvips-tools \
#     pandoc \
#     tidy \
#     make \
#     lsb-release \
#     zip 
    
# RUN curl -fsSL  ${SAXON_URL} -o /tmp/saxon.zip \
#     && unzip /tmp/saxon.zip -d /usr/local/share/${SAXON_VERSION} \
#     && echo "#! /bin/bash" > /usr/local/bin/saxon \
#     && echo "java -jar /usr/local/share/${SAXON_VERSION}/saxon-he-${SAXON_MAJOR}.${SAXON_MINOR}.jar \$*" >> /usr/local/bin/saxon \
#     && chmod 755 /usr/local/bin/saxon

# # Install sass (and any other globally necessary NPM modules)
# # Yarn is currently (2024-10-18) necessary for Wilde, but hopefully not for long
# RUN npm install --global \
#     sass \
#     yarn 

USER jenkins:jenkins
WORKDIR ${JENKINS_HOME}
RUN jenkins-plugin-cli --plugins \
        antisamy-markup-formatter \
        cloudbees-folder \
        copyartifact \
        docker-plugin \
        docker-workflow \
        build-timeout \
        credentials-binding \
        timestamper \
        ws-cleanup \
        workflow-aggregator \
        github-branch-source \
        git \
        github \
        pam-auth \
        ldap \
        email-ext \
        mailer \
        dark-theme

# Now copy and tar
# COPY jobs /tmp/jobs
# RUN tar cfz /usr/share/jenkins/ref/jobs.tar.gz -C /tmp/ jobs