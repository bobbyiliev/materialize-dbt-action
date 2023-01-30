FROM materialize/dbt-materialize:latest

LABEL maintainer="Materialize, Inc."
LABEL description="Materialize dbt adapter GitHub Action"

# Copy the profiles.yml file into the container
COPY profiles.yml.template /profiles.yml
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
