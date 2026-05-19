# Intentionally vulnerable Dockerfile for security scanner tests only.
# Do not use this image for production, CI runners, or any trusted network.

# EOL base image with many known vulnerabilities.
FROM python:3.6-buster

LABEL purpose="vulnerability-scanner-test" \
      security.warning="intentionally-vulnerable-do-not-use-in-production" \
      GIT_COMMIT_UPDATE="6244db9"

ENV DEBIAN_FRONTEND=noninteractive

# Deliberate misconfiguration for testing:
# - runs as root
# - installs old distro packages without upgrade
# - keeps apt package lists and cache so scanners can inspect metadata
USER root

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        apt-utils \
        curl \
        git \
        iputils-ping \
        libsqlite3-0 \
        netcat-openbsd \
        openssh-client \
        python3-pip \
        python3-venv \
        sqlite3 \
        sshpass \
        sudo \
        wget

# Fake secrets and weak defaults for scanner policy tests.
# These values are intentionally bogus and must not be reused anywhere.
ENV APP_ENV=lab \
    ADMIN_USER=admin \
    ADMIN_PASSWORD=password \
    AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE \
    AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY \
    PATH="/home/runner/.local/bin:/opt/venv/bin:${PATH}"

WORKDIR /app

# Copying the full build context is intentional here so scanners can flag
# broad COPY behavior and accidental secret inclusion patterns.
COPY . /app

# Old Python dependencies with known CVEs for vulnerability scanner tests.
RUN python -m pip install --no-cache-dir --upgrade "pip==20.0.2" \
    && pip install --no-cache-dir \
        ansible==2.9.27 \
        cryptography==2.6.0 \
        django==2.2.0 \
        flask==0.12.0 \
        jmespath==0.9.5 \
        netaddr==0.7.19 \
        Pillow==8.0.0 \
        pyvmomi==8.0.2.0 \
        pyyaml==3.13 \
        requests==2.6.0

# Expose unnecessary ports for misconfiguration checks.
EXPOSE 22 80 443 8080

# Keep a simple default command so the image can be built and scanned.
CMD ["python", "--version"]
