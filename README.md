# dbt Snowflake Analytics Project

This project demonstrates a basic analytics pipeline built using dbt (data build tool) and Snowflake. It transforms raw customer, order, and payment data into analytical models (`dim_customers`, `fct_orders`).

## Features

*   **Staging:** Cleans and standardizes raw data.
*   **Intermediate Models:** Performs reusable transformations (e.g., payment aggregation).
*   **Marts:** Creates final dimension and fact tables ready for BI or analysis.
*   **Testing:** Includes schema tests (unique, not_null, relationships, accepted_values) and custom data tests.
*   **Documentation:** Uses dbt's documentation features (`schema.yml`, `docs` blocks).
*   **Seeds:** Uses CSV files loaded via `dbt seed` for self-contained demo data.
*   **Macros:** Includes a simple example macro.

## Technologies

*   dbt Core
*   Snowflake
*   Python (for dbt CLI)

## Prerequisites

1.  **Snowflake Account:** Access to a Snowflake account where you have permissions to create databases, warehouses, roles, and users (or have an admin do it for you using the setup script).
2.  **dbt Core:** Installed locally. See [dbt installation guide](https://docs.getdbt.com/dbt-cli/installation). Recommend using `pip install dbt-snowflake`.
3.  **Python Environment:** A virtual environment is recommended (e.g., `python -m venv venv`).
4.  **Git:** For cloning the repository.

## Setup Instructions

1.  **Clone Repository:**
    ```bash
    git clone <your-repo-url>
    cd dbt_snowflake_analytics
    ```

2.  **Set up Python Environment (Recommended):**
    ```bash
    python -m venv venv
    source venv/bin/activate # Linux/macOS
    # .\venv\Scripts\activate # Windows
    pip install -r requirements.txt # (Create this file if needed, or just run pip install dbt-snowflake)
    # Or directly: pip install dbt-snowflake
    ```

3.  **Snowflake Setup:**
    *   Connect to your Snowflake account using a user with sufficient privileges (e.g., `ACCOUNTADMIN`, `SYSADMIN`).
    *   Execute the SQL commands provided in `snowflake_setup.sql` to create the necessary warehouse, database, role, and user for dbt.
    *   **Important:** Replace placeholder credentials (`YOUR_SECURE_PASSWORD`, `your_dbt_user`) in the script or preferably use secure methods like Key Pair authentication.

4.  **Configure dbt Profile:**
    *   **Copy Sample:** `cp profiles.yml.sample profiles.yml`
    *   **Set Environment Variables:** Set the following environment variables in your terminal session or using a `.env` file (ensure `.env` is in `.gitignore`). These correspond to the Snowflake objects created in the previous step and the credentials for the `your_dbt_user`.
        ```bash
        export SNOWFLAKE_ACCOUNT='<your_snowflake_account_locator.region>' # e.g., xy12345.us-east-1
        export SNOWFLAKE_USER='your_dbt_user' # The user created in snowflake_setup.sql
        export SNOWFLAKE_PASSWORD='YOUR_SECURE_PASSWORD' # The password set
        export SNOWFLAKE_ROLE='DBT_DEVELOPER_ROLE' # The role created
        export SNOWFLAKE_WAREHOUSE='DBT_DEVELOPMENT_WH' # The warehouse created
        export SNOWFLAKE_DATABASE='DBT_DEV_DB' # The database created
        export SNOWFLAKE_SCHEMA='dbt_yourinitials' # Choose a default schema for dbt runs, e.g., dbt_jsmith
        ```
    *   The `profiles.yml` file uses these environment variables, keeping secrets out of the file itself. **DO NOT** commit your actual `profiles.yml` file.

5.  **Install dbt Packages (if any):**
    ```bash
    dbt deps
    ```
    *(This project includes `dbt_utils` in `packages.yml`)*

## How to Run

1.  **Check Connection:** Verify dbt can connect to Snowflake.
    ```bash
    dbt debug
    ```

2.  **Load Raw Data:** Load the CSV data from the `seeds/` directory into the `RAW` schema in Snowflake (as configured in `dbt_project.yml`).
    ```bash
    dbt seed
    ```
    *Verify in Snowflake that tables `RAW_CUSTOMERS`, `RAW_ORDERS`, `RAW_PAYMENTS` exist in your `DBT_DEV_DB` database under the `RAW` schema.*

3.  **Run Models:** Execute the dbt models. This will build the staging views, intermediate views/tables, and final mart tables in the appropriate schemas (`STAGING`, `INTERMEDIATE`, `ANALYTICS`).
    ```bash
    dbt run
    ```
    *Verify in Snowflake that objects are created in the respective schemas.*

4.  **Run Tests:** Execute the tests defined in the `_sources.yml`, `_models.yml`, and `tests/custom/` directory.
    ```bash
    dbt test
    ```
    *This will run schema tests (unique, not_null, etc.) and custom data tests.*

5.  **Generate Documentation:** (Optional) Generate the dbt documentation website.
    ```bash
    dbt docs generate
    ```

6.  **Serve Documentation:** (Optional) View the documentation locally.
    ```bash
    dbt docs serve
    ```
    *Open your browser to `http://localhost:8080`.*

## Project Structure

*   `models/staging`: Base models, 1:1 with source tables. Renaming, casting.
*   `models/intermediate`: Models combining or transforming staging models.
*   `models/marts`: Final models for reporting/analytics (Dimensions & Facts).
*   `seeds`: Raw CSV data files.
*   `tests/custom`: Custom SQL-based data tests.
*   `macros`: Reusable SQL snippets.
*   `dbt_project.yml`: Main dbt configuration file.
*   `profiles.yml`: Snowflake connection details (via env vars). Not committed.
*   `packages.yml`: Declares dbt package dependencies.

## Next Steps / Improvements

*   Implement Snapshotting for Type 2 SCD (Slowly Changing Dimensions) on `dim_customers`.
*   Add more complex transformations or business logic.
*   Integrate with a BI tool.
*   Add CI/CD pipeline using GitHub Actions or similar.
*   Implement more sophisticated testing.
*   Use Key Pair Authentication for Snowflake.