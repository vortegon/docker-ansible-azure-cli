# pull base image
FROM mcr.microsoft.com/azure-cli:2.0.56

# Labels.
LABEL maintainer="victor347@gmail.com" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.vcs-ref=$VCS_REF \
    org.label-schema.name="vortegon/ansible" \
    org.label-schema.description="Ansible inside Docker" \
    org.label-schema.url="https://github.com/vortegon/docker-ansible" \
    org.label-schema.vcs-url="https://github.com/vortegon/docker-ansible" \
    org.label-schema.vendor="Victor Ortegon" \
    org.label-schema.docker.cmd="docker run --rm -it -v $(pwd):/ansible -v ~/.ssh/id_rsa:/root/id_rsa vortegon/ansible:latest"

###############################################################
# Install Ansible
RUN apk --no-cache add \
    sudo \
    openssl \
    ca-certificates \
    sshpass \
    openssh-client \
    rsync \
    git && \
    apk --no-cache add --virtual build-dependencies \
    libffi-dev \
    openssl-dev \
    build-base && \
    pip install --upgrade pip cffi && \
    pip install ansible==2.8.2 && \
    pip install mitogen ansible-lint && \
    pip install --upgrade pywinrm && \
    apk del build-dependencies && \
    rm -rf /var/cache/apk/*

RUN mkdir -p /etc/ansible && \
    echo 'localhost' > /etc/ansible/hosts

# install dependencies
RUN pip install packaging \
    && pip install azure-storage
