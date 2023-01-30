# Materialize dbt action

## Usage

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
        dbt_command: "dbt run --profiles-dir ."
        dbt_project_folder: "dbt_project"
      env:
        MZ_PASS: ${{ secrets.MZ_API_KEY }}
        MZ_USER: ${{ secrets.MZ_USER }}
        MZ_HOST: ${{ secrets.MZ_HOST }}
        MZ_PORT: ${{ env.MZ_PORT }}
        MZ_DB: ${{ env.MZ_DB }}
        MZ_SCHEMA: ${{ env.MZ_SCHEMA }}
        DBT_PROJECT_DIR: ${{ env.DBT_PROJECT_DIR }}
```
