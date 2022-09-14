{% docs __overview__ %}

# dbt Certification Exam Prep

## Source properties

This project uses all source properties dbt supports as of August 2022. 

Take a look at the `sources.md` file in the GitHub repo of this project for a summary of all of their functionalities.

## Node selection syntax

Nodes are the resources dbt supports - models, tests, sources, seeds, snapshots, exposures, and analyses. 

By default, using a dbt command like `dbt run` without adding a selector will run all models dbt finds in your project. To change this behavior, you need to use the `--select` flag and specify the model(s) you want to run. dbt also supports other flags that let you modify the number of resources your command works with upon execution. Below is a list of all of them:

| Command/Flag | `--select` | `--exclude` | `--selector` | `--resource-type` | `--defer` |
|--------------|:----------:|:-----------:|:------------:|:-----------------:|:---------:|
| run          |      ✓     |      ✓      |       ✓      |                   |     ✓     |
| test         |      ✓     |      ✓      |       ✓      |                   |     ✓     |
| seed         |      ✓     |      ✓      |       ✓      |                   |           |
| snapshot     |      ✓     |      ✓      |       ✓      |                   |           |
| is (list)    |      ✓     |      ✓      |       ✓      |         ✓         |           |
| compile      |      ✓     |      ✓      |       ✓      |                   |           |
| freshness    |      ✓     |      ✓      |       ✓      |                   |           |
| build        |      ✓     |      ✓      |       ✓      |         ✓         |     ✓     |

dbt gathers all resources by one or more of the `--select` criteria **in the order of selection methods** (e.g. `tag:`), then **graph operators** like `+`, then set operators (unions, intersections, exclusions).

The `--select` flag accepts one or more arguments. Each argument can be one of:

- a package name
- a model name
- a fully-qualified path to a directory of models
- a selection method (`path:`, `tag:`, `config:`, `test_type:`, `test_name:`)

### Examples:

    $ dbt run --select my_dbt_project_name   # runs all models in your project
    $ dbt run --select my_dbt_model          # runs a specific model
    $ dbt run --select path.to.my.models     # runs all models in a specific directory
    $ dbt run --select my_package.some_model # run a specific model in a specific package
    $ dbt run --select tag:nightly           # run models with the "nightly" tag
    $ dbt run --select path/to/models        # run models contained in path/to/models
    $ dbt run --select path/to/my_model.sql  # run a specific model by its path

dbt supports a shorthand language for defining subsets of nodes. This language uses the characters `+`, `@`, `*`, and `,`.

### Examples:

    $ dbt run --select my_first_model my_second_model                               # multiple arguments can be provided to --select
    $ dbt run --select tag:nightly my_model finance.base.*                          # these arguments can be projects, models, directory paths, tags, or sources
    $ dbt run --select path:marts/finance,tag:nightly,config.materialized:table     # use methods and intersections for more complex selectors

For frequent and more complex selections, it makes sence to use a YAML selector by utilizing the `--selector` flag. Selectors live in a top-level file named `selectors.yml`. Each must have a name and a definition, and can optionally define a description and default flag. Take a look at the `selectors.yml` for a simple selector that mimics the flag `--select tag:raw`.

## dbt_project.yml

This is the file that contains the project's main configurations. Take a look at the `dbt_project.yml` file at the top of the project for details about all possible properties.

## Creating a dbt project from scratch

Detailed guides on how to build a basic dbt project from scratch can be found in the documentation pages for [dbt Cloud](https://docs.getdbt.com/guides/getting-started/building-your-first-project) and [dbt Core](https://docs.getdbt.com/dbt-cli/cli-overview).

## Debugging errors

A comprehensive guide on how to troubleshoot and debug dbt errors can be found [here](https://docs.getdbt.com/guides/legacy/debugging-errors).

## General resource properties

Please refer to the docs [here](https://docs.getdbt.com/reference/resource-properties/columns#) and the `.yml` files across the project for examples of the resource properties that can be used in dbt.

## Main operations

|      **Command**     |                                                                                                                                                                                       **Effect**                                                                                                                                                                                       |                                                             **Useful for**                                                             |
|:--------------------:|:--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------:|:--------------------------------------------------------------------------------------------------------------------------------------:|
| dbt compile          | Generates executable SQL from source model, test and analysis files                                                                                                                                                                                                                                                                                                                    | - Visually inspecting compiled output of model files - Generating SQL to run manually in the data warehouse - Compiling analysis files |
| dbt run              | Executes compiled SQL models against the target database. Using it with the `--select` flag limits the execution to the models specified. Using it with `--full-refresh` flag rebuilds incremental models from scratch.                                                                                                                                                                | - Materialising new models - Rebuilding existing models                                                                                |
| dbt source freshness | Checks if the source's `loaded_at_field` complies with the freshness conditions specified in the source's `.yml` file. Results are stored in `target/sources.json`, which can be changed by using the `--output` tag when running the command, e.g. `dbt source freshness --output new_target/source_freshness.json`                                                                   | - Checking if a specific data source is in a delayed state - Checking the trend of data source freshness over time                     |
| dbt test             | Runs all configured tests on models and sources. Can be used with the `--select` flag to limit tested resources. Selection can also be limited based on test type, e.g. `dbt test --select model_a, test_type:generic` will only run the generic tests in `model_a`                                                                                                                    | - Confirming your code works - Preventing errors when the code changes                                                                 |
| dbt docs generate    | Generating your project's documentation website by:  1. Copying the website `index.html` file into the `target/` directory 2. Compiling the project to `target/manifest.json` 3. Producing the `target/catalog.json` file, which contains metadata about the tables and views produced by the models in your project  Using the `--no-compile` argument skips re-compilation (step 2). | - Generating docs for your project - Refreshing docs for the project upon updates                                                      |
| dbt build            | Executes `run`, `test`, `snapshot` and `seed` in DAG order, producing a single `manifest.json` and a single `run_results.json` file that contain information about all models, tests, seeds and snapshots that were selected to build.  **Failing tests prevent downstream models from running.** To prevent that, add a `severity: warn` config to the tests.                         | - The need arises for `run`, `test`, `snapshot` and `seed` to be executes simultaneously                                               |
| dbt run-operation    | Executing a macro. Using the `--args` flag will map the arguments provided to the arguments of the macro when calling it, e.g. `dbt run-operation`                                                                                                                                                                                                                                     | - The need arises to execute a macro without running a model                                                                           |

{% enddocs %}

{% docs __dbt_utils__ %}
 This is a test.
{% enddocs %}