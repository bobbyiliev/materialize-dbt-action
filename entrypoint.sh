#!/bin/bash

set -o pipefail

python3 -m venv dbt
source dbt/bin/activate

if [ -z ${DBT_MZ_VERSION} ]
then
  echo "DBT_MZ_VERSION is empty, installing the latest version"
  pip install dbt-materialize
else
  echo "Installing dbt-materialize version ${DBT_MZ_VERSION}"
  pip install dbt-materialize==${DBT_MZ_VERSION}
fi

dbt_project_folder=${DBT_PROJECT_FOLDER:-./}

echo "dbt project folder set as: \"${dbt_project_folder}\""

# Check if the `profiles.yml` file exists in the project folder
if [ -f "${dbt_project_folder}/profiles.yml" ]
then
  echo "profiles.yml file exists in the project folder"
else
  echo "profiles.yml file does not exist in the project folder"
  echo "Copying the profiles.yml file to the project folder"
  mkdir /github/home/.dbt
  cp /profiles.yml /github/home/.dbt
fi

cd ${dbt_project_folder}

# Create a `profiles.yml` file
echo "Checking the environment variables"
if [ -z ${MZ_USER} ]
then
  echo "MZ_USER is empty"
  exit 1
fi

if [ -z ${MZ_PASS} ]
then
  echo "MZ_PASS is empty"
  exit 1
fi

if [ -z ${MZ_HOST} ]
then
  echo "MZ_HOST is empty"
  exit 1
fi

if [ -z ${MZ_CLUSTER} ]
then
  echo "MZ_CLUSTER is empty, setting to 'default'"
  export MZ_CLUSTER='default'
fi

if [ -z ${MZ_DATABASE} ]
then
  echo "MZ_DATABASE is empty, setting to 'materialize'"
  export MZ_DATABASE='materialize'
fi

if [ -z ${MZ_SCHEMA} ]
then
  echo "MZ_SCHEMA is empty, setting to 'public'"
  export MZ_SCHEMA='public'
fi

if [ -z ${MZ_DEBUG} ]
then
  pwd
  ls -lah
fi

DBT_ACTION_LOG_FILE=${DBT_ACTION_LOG_FILE:="dbt_console_output.txt"}
DBT_ACTION_LOG_PATH="${DBT_PROJECT_FOLDER}/${DBT_ACTION_LOG_FILE}"
echo "DBT_ACTION_LOG_PATH=${DBT_ACTION_LOG_PATH}" >> $GITHUB_ENV
echo "saving console output in \"${DBT_ACTION_LOG_PATH}\""
$1 2>&1 | tee "${DBT_ACTION_LOG_FILE}"
if [ $? -eq 0 ]
  then
    echo "DBT_RUN_STATE=passed" >> $GITHUB_STATE
    echo "result=passed" >> $GITHUB_OUTPUT
    echo "DBT run OK" >> "${DBT_ACTION_LOG_FILE}"
  else
    echo "DBT_RUN_STATE=failed" >> $GITHUB_STATE
    echo "result=failed" >> $GITHUB_OUTPUT
    echo "DBT run failed" >> "${DBT_ACTION_LOG_FILE}"
    exit 1
fi
