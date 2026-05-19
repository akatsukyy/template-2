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
        nodejs \
        npm \
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

# GHSA-wx9m-wx4f-4cmg:
# mistralai==2.4.6 is a malicious PyPI release with no patched version.
# Keep it in the standard Python dependency manifest so scanners can flag it.
# Do not pip install or import it: the advisory states the dropper triggers on
# Linux import.
RUN printf '%s\n' \
        '# Intentionally vulnerable dependency manifest for scanner tests only.' \
        '# GHSA-wx9m-wx4f-4cmg: malicious dropper in mistralai 2.4.6.' \
        'mistralai==2.4.6' \
        > /app/requirements.txt \
    && mkdir -p /usr/local/lib/python3.6/site-packages/mistralai-2.4.6.dist-info \
    && printf '%s\n' \
        'Metadata-Version: 2.1' \
        'Name: mistralai' \
        'Version: 2.4.6' \
        'Summary: Scanner fixture metadata only. The malicious package code is not installed.' \
        > /usr/local/lib/python3.6/site-packages/mistralai-2.4.6.dist-info/METADATA

# GHSA-rpr9-rxv7-x643 / CVE-2026-44990:
# sanitize-html <= 2.17.3 has default XSS via xmp raw-text passthrough.
# Patched version is listed as None in the advisory.
RUN printf '%s\n' \
        '{' \
        '  "name": "intentionally-vulnerable-scanner-fixture",' \
        '  "version": "1.0.0",' \
        '  "private": true,' \
        '  "description": "Intentionally vulnerable npm manifest for scanner tests only.",' \
        '  "dependencies": {' \
        '    "sanitize-html": "2.17.3"' \
        '  }' \
        '}' \
        > /app/package.json \
    && npm install --production

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
