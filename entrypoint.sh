#!/bin/bash

set -o pipefail

echo "dbt project folder set as: \"${DBT_PROJECT_FOLDER}\""
cd ${DBT_PROJECT_FOLDER}

# Create a `profiles.yml` file
echo "Updating profiles.yml"
if [ -z "$MZ_USER" ]
then
  echo "MZ_USER is empty"
  exit 1
else
  sed -i "s/MZ_USER/${MZ_USER}/g" ~/.dbt/profiles.yml
fi

if [ -z "$MZ_PASS" ]
then
  echo "MZ_PASS is empty"
  exit 1
else
  sed -i "s/MZ_PASS/${MZ_PASS}/g" ~/.dbt/profiles.yml
fi

if [ -z "$MZ_HOST" ]
then
  echo "MZ_HOST is empty"
  exit 1
else
  sed -i "s/MZ_HOST/${MZ_HOST}/g" ~/.dbt/profiles.yml
fi

if [ -z "$MZ_PORT" ]
then
  sed -i "s/MZ_PORT/6875/g" ~/.dbt/profiles.yml
else
  sed -i "s/MZ_PORT/${MZ_PORT}/g" ~/.dbt/profiles.yml
fi

if [ -z "$MZ_DB" ]
then
  sed -i "s/MZ_DB/materialize/g" ~/.dbt/profiles.yml
else
  sed -i "s/MZ_DB/${MZ_DB}/g" ~/.dbt/profiles.yml
fi

if [ -z "$MZ_SCHEMA" ]
then
  sed -i "s/MZ_SCHEMA/public/g" ~/.dbt/profiles.yml
else
  sed -i "s/MZ_SCHEMA/${MZ_SCHEMA}/g" ~/.dbt/profiles.yml
fi

if [ -z "$MZ_CLUSTER" ]
then
  sed -i "s/MZ_CLUSTER/mz_introspection/g" ~/.dbt/profiles.yml
else
  sed -i "s/MZ_CLUSTER/${MZ_CLUSTER}/g" ~/.dbt/profiles.yml
fi

DBT_ACTION_LOG_FILE=${DBT_ACTION_LOG_FILE:="dbt_console_output.txt"}
DBT_ACTION_LOG_PATH="${DBT_PROJECT_FOLDER}/${DBT_ACTION_LOG_FILE}"
echo "DBT_ACTION_LOG_PATH=${DBT_ACTION_LOG_PATH}" >> $GITHUB_ENV
echo "saving console output in \"${DBT_ACTION_LOG_PATH}\""
$1 2>&1 | tee "${DBT_ACTION_LOG_FILE}"
if [ $? -eq 0 ]
  then
    echo "DBT_RUN_STATE=passed" >> $GITHUB_ENV
    echo "::set-output name=result::passed"
    echo "DBT run OK" >> "${DBT_ACTION_LOG_FILE}"
  else
    echo "DBT_RUN_STATE=failed" >> $GITHUB_ENV
    echo "::set-output name=result::failed"
    echo "DBT run failed" >> "${DBT_ACTION_LOG_FILE}"
    exit 1
fi
