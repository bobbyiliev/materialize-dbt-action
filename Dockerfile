FROM materialize/dbt-materialize:latest

LABEL maintainer="Materialize, Inc."
LABEL description="Materialize dbt adapter GitHub Action"

RUN mkdir -p ~/.dbt

COPY profile.yml.template ~/.dbt/profile.yml
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
