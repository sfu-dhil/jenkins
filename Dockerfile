# Docker file for the DHIL's Jenkins (experimental)
# This is mostly derived from the TEI's, but modified for
# our needs


FROM jenkins/jenkins:lts
ARG NODE_MAJOR=22
ENV LC_ALL=C.UTF-8
ENV LANG=C.UTF-8

USER root

# ca-certificates because curl uses certificates from ca-certificates
RUN apt-get update && apt-get install -y --no-install-recommends ca-certificates curl gnupg && \
    # Installing nodejs
    mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg && \
    echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list && \
    apt-get update && apt-get install nodejs -y && apt-get clean && rm -rf /var/lib/apt/lists/* 

RUN apt-get update && apt-get -y --no-install-recommends --no-install-suggests install \
    ant \
    ant-optional \
    ant-contrib \
    debhelper \
    jing \
    imagemagick \
    libjing-java \ 
    libsaxon-java \ 
    libsaxonhe-java \
    libxml2-utils \ 
    tidy \
    make \
    lsb-release \
    zip 
    
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

# Install sass, since it's used in a lot of places
RUN npm install sass -g

# Create a `saxon` exec  
RUN echo "#! /bin/bash" > /usr/local/bin/saxon \
    && echo "java -jar /usr/share/java/Saxon-HE.jar \$*" >> /usr/local/bin/saxon \
    && chmod 755 /usr/local/bin/saxon

USER jenkins:jenkins
WORKDIR ${JENKINS_HOME}
RUN jenkins-plugin-cli --plugins \
        antisamy-markup-formatter \
        cloudbees-folder \
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

COPY jobs /tmp/jobs

RUN tar cfz /usr/share/jenkins/ref/jobs.tar.gz -C /tmp/ jobs