FROM ghcr.io/actions/actions-runner:2.333.0
LABEL GIT_COMMIT_UPDATE=6244db9

ENV DEBIAN_FRONTEND=noninteractive
ARG RUNNER_VERSION
USER root

# Install necessary packages
RUN apt-get -y update \
  && apt-get --no-install-recommends install -y apt-utils wget python3-pip python3-venv sshpass iputils-ping \
  && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/ \
  && apt-get autoclean \
  && apt-get autoremove -y

# Create Python virtual environment
RUN python3 -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"


# Install ansible
RUN pip install --no-cache-dir ansible-core==2.16.5 jmespath netaddr requests pyvmomi==8.0.2.0 \
  && pip install --no-cache-dir ansible==7.6.0 --no-deps

ENV PATH="/home/runner/.local/bin:${PATH}"

USER root
