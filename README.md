# Materialize dbt action

A GitHub action that runs dbt commands against a Materialize instance.

## Required secrets

The following secrets are required:

| Name | Description | Example |
| ---- | ----------- | ------- |
| `MZ_PASS` | The password for the Materialize user. | `MZ_PASS: ${{ secrets.MZ_PASS }}` |
| `MZ_USER` | The username for the Materialize user. | `MZ_USER: ${{ secrets.MZ_USER }}` |
| `MZ_HOST` | The host for the Materialize instance. | `MZ_HOST: ${{ secrets.MZ_HOST }}` |


## Usage

Create a new workflow file in your repository, for example `.github/workflows/materialize-dbt-action.yml` and add the following content:

```yaml
name: Materialize dbt action
on:
  push:
    branches:
      - main

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
      with:
        fetch-depth: 0
    - name: Materialize dbt action
      uses: bobbyiliev/materialize-dbt-action@main
      with:
        dbt_command: "dbt --version --profiles-dir /profiles.yml"
      env:
        MZ_PASS: ${{ secrets.MZ_PASS }}
        MZ_USER: ${{ secrets.MZ_USER }}
        MZ_HOST: ${{ secrets.MZ_HOST }}
        MZ_PORT: 6875
        MZ_DATABASE: materialize
        MZ_SCHEMA: public
        MZ_CLUSTER: default
        DBT_PROJECT_FOLDER: ${{ env.DBT_PROJECT_FOLDER }}
```

The above will run the `dbt --version` command against a Materialize instance on every push to the `main` branch.

To run on a pull request, change the `on` section to:

```yaml
on:
  pull_request:
    branches:
      - main
```

## Inputs

### `dbt_command`

**Required** The dbt command to run. Default `"dbt --version --profiles-dir /profiles.yml"`. You can change this to run any dbt command.

## Overriding the default `profiles.yml`

You can override the default `profiles.yml` by creating a new file in your repository called `/profiles.yml` and add the following content:

```yaml
Add the following `profiles.yml` file to your dbt project:

```yaml
default:
  outputs:
    default:
      type: materialize
      threads: 1
      user: "{{ env_var('MZ_USER')}}"
      pass: "{{ env_var('MZ_PASS')}}"
      host: "{{ env_var('MZ_HOST')}}"
      port: 6875
      database: materialize
      schema: public
      cluster: mz_introspection
      sslmode: require

  target: default
```

Then change the `dbt_command` input to `"dbt --version --profiles-dir profiles.yml"`.

This will override the default `profiles.yml` file and use the one from your repository.

## `DBT_PROJECT_FOLDER`

You can specify a custom dbt project folder by setting the `DBT_PROJECT_FOLDER` environment variable. This is useful if you have multiple dbt projects in the same repository.
