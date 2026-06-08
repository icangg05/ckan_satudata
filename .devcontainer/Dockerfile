# [Choice] Python version: 3.10-bookworm
ARG VARIANT=3.10-bookworm
# FROM mcr.microsoft.com/vscode/devcontainers/python:${VARIANT}
FROM mcr.microsoft.com/devcontainers/python:${VARIANT}

ENV PYTHONUNBUFFERED 1

# Update args in docker-compose.yaml to set the UID/GID of the "vscode" user.
ARG USER_UID=1000
ARG USER_GID=$USER_UID
RUN if [ "$USER_GID" != "1000" ] || [ "$USER_UID" != "1000" ]; then groupmod --gid $USER_GID vscode && usermod --uid $USER_UID --gid $USER_GID vscode; fi

# [Choice] Node.js version: none, lts/*, 16, 14, 12, 10
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi

# [Optional] If your requirements rarely change, uncomment this section to add them to the image.
# COPY requirements.txt /tmp/pip-tmp/
# RUN pip3 --disable-pip-version-check --no-cache-dir install -r /tmp/pip-tmp/requirements.txt \
#    && rm -rf /tmp/pip-tmp

# Fix: Hapus repo Yarn yang expired GPG key-nya, lalu install postgresql-client
RUN rm -f /etc/apt/sources.list.d/yarn.list \
  && apt-get update && export DEBIAN_FRONTEND=noninteractive \
  && apt-get -y install --no-install-recommends \
  postgresql-client

# Install CKAN dependencies & package saat build image
COPY requirements.txt /tmp/pip-tmp/requirements.txt
RUN pip install -r /tmp/pip-tmp/requirements.txt && rm -rf /tmp/pip-tmp

# Auto-generate ckan.ini jika belum ada, lalu jalankan CKAN
COPY .devcontainer/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
