FROM python:3.10.7-slim-bullseye

# System setup
RUN apt-get update \
  && apt-get dist-upgrade -y \
  && apt-get install -y \
    git \
    libpq-dev \
    libssl-dev \
    libffi-dev \
    build-essential

LABEL maintainer="Materialize, Inc."
LABEL description="Materialize dbt adapter GitHub Action"

# Copy the profiles.yml file into the container
COPY profiles.yml.template /profiles.yml
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
