//=============================================================================
// create warehouses
//=============================================================================
USE ROLE SYSADMIN;

// reporting warehouse
CREATE WAREHOUSE
    SIGMA_CLOUD_COST_MONITORING_REPORTING_WH
    COMMENT='Warehouse for powering reporting queries from Sigma'
    WAREHOUSE_SIZE=XSMALL
    AUTO_SUSPEND=60
    INITIALLY_SUSPENDED=TRUE;
//=============================================================================


//=============================================================================
// create object access roles for warehouses
//=============================================================================
USE ROLE SECURITYADMIN;

// reporting roles for the sigma service account
CREATE ROLE SIGMA_CLOUD_COST_MONITORING_REPORTING_WH_USAGE;

// grant all roles to sysadmin (always do this)
GRANT ROLE SIGMA_CLOUD_COST_MONITORING_REPORTING_WH_USAGE TO ROLE SYSADMIN;
//=============================================================================


//=============================================================================
// grant privileges to object access roles
//=============================================================================
USE ROLE SECURITYADMIN;

// reporting permissions
GRANT USAGE ON WAREHOUSE SIGMA_CLOUD_COST_MONITORING_REPORTING_WH TO ROLE SIGMA_CLOUD_COST_MONITORING_REPORTING_WH_USAGE;
//=============================================================================


//=============================================================================
// create business function roles and grant access to object access roles
//=============================================================================
USE ROLE SECURITYADMIN;
 
// reporter roles
CREATE ROLE SIGMA_CLOUD_COST_MONITORING_REPORTER;
GRANT ROLE SIGMA_CLOUD_COST_MONITORING_REPORTER TO ROLE SYSADMIN;

// grant OA roles to BF roles
GRANT ROLE CLOUD_COST_MONITORING_PROD_REPORTING_READ      TO ROLE SIGMA_CLOUD_COST_MONITORING_REPORTER;
GRANT ROLE SIGMA_CLOUD_COST_MONITORING_REPORTING_WH_USAGE TO ROLE SIGMA_CLOUD_COST_MONITORING_REPORTER;
//=============================================================================


//=============================================================================
// create service account
//=============================================================================
USE ROLE SECURITYADMIN;
 
// create service account
CREATE USER 
  SIGMA_CLOUD_COST_MONITORING_SERVICE_ACCOUNT
  PASSWORD = 'my cool password here' // use your own password 
  COMMENT = 'Service account for connecting Sigma Computing to Snowflake for Cloud Cost Monitoring reports.'
  DEFAULT_WAREHOUSE = SIGMA_CLOUD_COST_MONITORING_REPORTING_WH
  DEFAULT_ROLE = SIGMA_CLOUD_COST_MONITORING_REPORTER
  MUST_CHANGE_PASSWORD = FALSE;

// grant permissions to service account
GRANT ROLE SIGMA_CLOUD_COST_MONITORING_REPORTER TO USER SIGMA_CLOUD_COST_MONITORING_SERVICE_ACCOUNT;
//=============================================================================
