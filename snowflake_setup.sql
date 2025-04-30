-- *********************************************************************--
-- Setup Script for dbt_snowflake_analytics Project
-- *********************************************************************--
-- Replace placeholders like 'YOUR_PASSWORD', 'your_dbt_user', etc.
-- Best practice: Use Key Pair Authentication instead of passwords for users.
--                This script uses password for simplicity in setup.
-- *********************************************************************--

-- Use a high-privilege role like ACCOUNTADMIN temporarily for setup,
-- or ensure your current role has CREATE DATABASE, CREATE WAREHOUSE, CREATE ROLE, CREATE USER privileges.
USE ROLE ACCOUNTADMIN; -- Or SYSADMIN if sufficient

-- 1. Create Warehouse (Adjust size/settings as needed)
CREATE WAREHOUSE IF NOT EXISTS DBT_DEVELOPMENT_WH
  WAREHOUSE_SIZE = XSMALL
  AUTO_SUSPEND = 60 -- Suspend after 60 seconds of inactivity
  AUTO_RESUME = TRUE
  INITIALLY_SUSPENDED = TRUE;

-- 2. Create Database for Development
CREATE DATABASE IF NOT EXISTS DBT_DEV_DB;

-- 3. Create Role for dbt Development Usage
CREATE ROLE IF NOT EXISTS DBT_DEVELOPER_ROLE;

-- 4. Create User for dbt (Replace 'your_dbt_user' and 'YOUR_SECURE_PASSWORD')
--    IMPORTANT: Consider using Key Pair Auth instead for better security.
--    If using Key Pair: Generate keys, assign PUBLIC key here, store PRIVATE key securely.
CREATE USER IF NOT EXISTS your_dbt_user
  PASSWORD = 'YOUR_SECURE_PASSWORD' -- REPLACE THIS!
  LOGIN_NAME = 'your_dbt_user'      -- Can be the same as user name
  DISPLAY_NAME = 'dbt Development User'
  DEFAULT_WAREHOUSE = DBT_DEVELOPMENT_WH
  DEFAULT_ROLE = DBT_DEVELOPER_ROLE
  MUST_CHANGE_PASSWORD = FALSE; -- Set to TRUE for first login if desired

-- 5. Grant Role to User
GRANT ROLE DBT_DEVELOPER_ROLE TO USER your_dbt_user;

-- 6. Grant Privileges to the dbt Role
--    Usage on warehouse
GRANT USAGE ON WAREHOUSE DBT_DEVELOPMENT_WH TO ROLE DBT_DEVELOPER_ROLE;

--    Usage on database
GRANT USAGE ON DATABASE DBT_DEV_DB TO ROLE DBT_DEVELOPER_ROLE;

--    Grant privileges on ALL SCHEMAS *within* the dev database.
--    dbt needs to create schemas (raw, staging, intermediate, analytics)
GRANT CREATE SCHEMA ON DATABASE DBT_DEV_DB TO ROLE DBT_DEVELOPER_ROLE;

--    Grant full privileges on *future* tables/views within the schemas dbt will manage.
--    This is crucial so dbt can operate without needing GRANTs after every run.
--    Grant permissions for the schemas dbt will create (as defined in dbt_project.yml):
GRANT ALL PRIVILEGES ON FUTURE SCHEMAS IN DATABASE DBT_DEV_DB TO ROLE DBT_DEVELOPER_ROLE;
GRANT ALL PRIVILEGES ON FUTURE TABLES IN DATABASE DBT_DEV_DB TO ROLE DBT_DEVELOPER_ROLE;
GRANT ALL PRIVILEGES ON FUTURE VIEWS IN DATABASE DBT_DEV_DB TO ROLE DBT_DEVELOPER_ROLE;

--    Optional: If you manually create the schemas first (e.g., RAW, STAGING, ANALYTICS),
--    you might need to grant specific usage on them first.
--    Example: GRANT USAGE ON SCHEMA DBT_DEV_DB.RAW TO ROLE DBT_DEVELOPER_ROLE;
--    However, the CREATE SCHEMA grant and FUTURE grants should cover dbt's needs.

-- 7. Verify (Optional)
SHOW GRANTS TO ROLE DBT_DEVELOPER_ROLE;
SHOW GRANTS TO USER your_dbt_user;

-- *********************************************************************--
-- Setup Complete. Now configure your profiles.yml!
-- Remember to set Environment Variables for credentials.
-- *********************************************************************--

-- Example Environment Variable setup (bash/zsh):
-- export SNOWFLAKE_ACCOUNT='your_account.region'
-- export SNOWFLAKE_USER='your_dbt_user'
-- export SNOWFLAKE_PASSWORD='YOUR_SECURE_PASSWORD'
-- export SNOWFLAKE_ROLE='DBT_DEVELOPER_ROLE'
-- export SNOWFLAKE_WAREHOUSE='DBT_DEVELOPMENT_WH'
-- export SNOWFLAKE_DATABASE='DBT_DEV_DB'
-- export SNOWFLAKE_SCHEMA='dbt_yourinitials' # This schema is the default target schema