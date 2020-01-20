/**
    This script creates the top-level objects for the
    Cloud Cost Monitoring initiative in Snowflake. It also
    creates corresponding object access roles to assign to 
    business function roles as needed.
**/
//=============================================================================
// create databases
//=============================================================================
USE ROLE SYSADMIN;

// Databases
CREATE DATABASE CLOUD_COST_MONITORING_DEV;     // local dbt targets this db from developer machines
CREATE DATABASE CLOUD_COST_MONITORING_TEST;    // CI from pull requests happens here
CREATE DATABASE CLOUD_COST_MONITORING_PROD;    // CI from merges to master happens here 

// Reporting schema. This must exist now for reporter permissions.
CREATE SCHEMA CLOUD_COST_MONITORING_PROD.REPORTING;
//=============================================================================


//=============================================================================
// create warehouses
//=============================================================================
USE ROLE SYSADMIN;

// dev warehouse
CREATE WAREHOUSE
    CLOUD_COST_MONITORING_DEV_WH
    COMMENT='Warehouse for powering developer activities for the cloud cost monitoring project'
    WAREHOUSE_SIZE=XSMALL
    AUTO_SUSPEND=60
    INITIALLY_SUSPENDED=TRUE;

// test warehouse
CREATE WAREHOUSE
    CLOUD_COST_MONITORING_TEST_WH
    COMMENT='Warehouse for powering CI test activities for the cloud cost monitoring project'
    WAREHOUSE_SIZE=XSMALL
    AUTO_SUSPEND=60
    INITIALLY_SUSPENDED=TRUE;

// prod warehouse
CREATE WAREHOUSE
    CLOUD_COST_MONITORING_PROD_WH
    COMMENT='Warehouse for powering CI prod activities for the cloud cost monitoring project'
    WAREHOUSE_SIZE=XSMALL
    AUTO_SUSPEND=60
    INITIALLY_SUSPENDED=TRUE;
//=============================================================================


//=============================================================================
// create object access roles for databases
//=============================================================================
USE ROLE SECURITYADMIN;

// dev roles
CREATE ROLE CLOUD_COST_MONITORING_DEV_READ_WRITE;

// test roles
CREATE ROLE CLOUD_COST_MONITORING_TEST_READ_WRITE;

// prod roles
CREATE ROLE CLOUD_COST_MONITORING_PROD_READ_WRITE;

// prod reporting roles
CREATE ROLE CLOUD_COST_MONITORING_PROD_REPORTING_READ;

// grant all roles to sysadmin (always do this)
GRANT ROLE CLOUD_COST_MONITORING_DEV_READ_WRITE      TO ROLE SYSADMIN;
GRANT ROLE CLOUD_COST_MONITORING_TEST_READ_WRITE     TO ROLE SYSADMIN;
GRANT ROLE CLOUD_COST_MONITORING_PROD_READ_WRITE     TO ROLE SYSADMIN;
GRANT ROLE CLOUD_COST_MONITORING_PROD_REPORTING_READ TO ROLE SYSADMIN;
//=============================================================================


//=============================================================================
// create object access roles for warehouses
//=============================================================================
USE ROLE SECURITYADMIN;

// dev roles
CREATE ROLE CLOUD_COST_MONITORING_DEV_WH_ALL;

// test for ci (not for humans)
CREATE ROLE CLOUD_COST_MONITORING_TEST_WH_USAGE;

// prod roles for ci (also not for humans)
CREATE ROLE CLOUD_COST_MONITORING_PROD_WH_USAGE;

// grant all roles to sysadmin (always do this)
GRANT ROLE CLOUD_COST_MONITORING_DEV_WH_ALL               TO ROLE SYSADMIN;
GRANT ROLE CLOUD_COST_MONITORING_TEST_WH_USAGE            TO ROLE SYSADMIN;
GRANT ROLE CLOUD_COST_MONITORING_PROD_WH_USAGE            TO ROLE SYSADMIN;
//=============================================================================
 

//=============================================================================
// grant privileges to object access roles
//=============================================================================
USE ROLE SECURITYADMIN;

// dev permissions
GRANT CREATE SCHEMA, USAGE ON DATABASE CLOUD_COST_MONITORING_DEV TO ROLE CLOUD_COST_MONITORING_DEV_READ_WRITE;
GRANT ALL PRIVILEGES ON WAREHOUSE CLOUD_COST_MONITORING_DEV_WH   TO ROLE CLOUD_COST_MONITORING_DEV_WH_ALL;

// test permissions
GRANT CREATE SCHEMA, USAGE ON DATABASE CLOUD_COST_MONITORING_TEST TO ROLE CLOUD_COST_MONITORING_TEST_READ_WRITE;
GRANT USAGE ON WAREHOUSE CLOUD_COST_MONITORING_TEST_WH            TO ROLE CLOUD_COST_MONITORING_TEST_WH_USAGE;

// prod permissions
GRANT CREATE SCHEMA, USAGE ON DATABASE CLOUD_COST_MONITORING_PROD TO ROLE CLOUD_COST_MONITORING_PROD_READ_WRITE;
GRANT USAGE ON WAREHOUSE CLOUD_COST_MONITORING_PROD_WH            TO ROLE CLOUD_COST_MONITORING_PROD_WH_USAGE;

// transfer reporting schema ownership 
USE ROLE SYSADMIN;
GRANT OWNERSHIP ON SCHEMA CLOUD_COST_MONITORING_PROD.REPORTING TO ROLE CLOUD_COST_MONITORING_PROD_READ_WRITE;

// reporting permissions
USE ROLE SECURITYADMIN;
GRANT USAGE ON DATABASE CLOUD_COST_MONITORING_PROD                           TO ROLE CLOUD_COST_MONITORING_PROD_REPORTING_READ;
GRANT USAGE ON SCHEMA CLOUD_COST_MONITORING_PROD.REPORTING                   TO ROLE CLOUD_COST_MONITORING_PROD_REPORTING_READ;
GRANT SELECT ON ALL TABLES IN SCHEMA CLOUD_COST_MONITORING_PROD.REPORTING    TO ROLE CLOUD_COST_MONITORING_PROD_REPORTING_READ;
GRANT SELECT ON FUTURE TABLES IN SCHEMA CLOUD_COST_MONITORING_PROD.REPORTING TO ROLE CLOUD_COST_MONITORING_PROD_REPORTING_READ;
GRANT SELECT ON ALL VIEWS IN SCHEMA CLOUD_COST_MONITORING_PROD.REPORTING     TO ROLE CLOUD_COST_MONITORING_PROD_REPORTING_READ;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA CLOUD_COST_MONITORING_PROD.REPORTING  TO ROLE CLOUD_COST_MONITORING_PROD_REPORTING_READ;
//=============================================================================


//=============================================================================
// create business function roles and grant access to object access roles
//=============================================================================
USE ROLE SECURITYADMIN;
 
// transformer roles
CREATE ROLE CLOUD_COST_MONITORING_DEV_TRANSFORMER;
CREATE ROLE CLOUD_COST_MONITORING_TEST_TRANSFORMER;
CREATE ROLE CLOUD_COST_MONITORING_PROD_TRANSFORMER;

// dev OA roles
GRANT ROLE CLOUD_COST_MONITORING_DEV_READ_WRITE TO ROLE CLOUD_COST_MONITORING_DEV_TRANSFORMER;
GRANT ROLE CLOUD_COST_MONITORING_DEV_WH_ALL     TO ROLE CLOUD_COST_MONITORING_DEV_TRANSFORMER;

// test OA roles
GRANT ROLE CLOUD_COST_MONITORING_TEST_READ_WRITE TO ROLE CLOUD_COST_MONITORING_TEST_TRANSFORMER;
GRANT ROLE CLOUD_COST_MONITORING_TEST_WH_USAGE   TO ROLE CLOUD_COST_MONITORING_TEST_TRANSFORMER;

// prod OA roles 
GRANT ROLE CLOUD_COST_MONITORING_PROD_READ_WRITE TO ROLE CLOUD_COST_MONITORING_PROD_TRANSFORMER;
GRANT ROLE CLOUD_COST_MONITORING_PROD_WH_USAGE   TO ROLE CLOUD_COST_MONITORING_PROD_TRANSFORMER;
//=============================================================================
