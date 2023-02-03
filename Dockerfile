FROM python:3.10.7-slim-bullseye

LABEL maintainer="Materialize, Inc."
LABEL description="Materialize dbt adapter GitHub Action"

ARG DBT_VERSION=1.3.2
ARG MZ_VERSION=1.3.4

# System setup
RUN apt-get update \
  && apt-get dist-upgrade -y

# Install dbt and Materialize adapter
RUN python -m pip install --upgrade pip setuptools wheel --no-cache-dir \
  && pip install dbt-core==${DBT_VERSION} --no-cache-dir \
  && pip install dbt-materialize==${MZ_VERSION} --no-cache-dir

# Copy the profiles.yml file into the container
COPY profiles.yml.template /profiles.yml
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
