FROM jenkins/jenkins:2.492.1-lts-jdk21

# setup docker cli
USER root
RUN apt-get update && apt-get install -y gnupg2 lsb-release \
  && curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc https://download.docker.com/linux/debian/gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.asc] https://download.docker.com/linux/debian $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list \
  && apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io \
  && usermod -a -G docker jenkins \
  && groupmod -g 992 docker \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# setup jenkins plugins
USER jenkins
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