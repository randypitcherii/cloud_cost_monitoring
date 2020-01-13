// build top level resources
use role sysadmin;

create database if not exists dev_dbt;
grant ownership on database dev_dbt to role rte;

create database if not exists prod_dbt;
grant ownership on database prod_dbt to role rte;

create database if not exists ci_dbt;
grant ownership on database ci_dbt to role rte;

create warehouse if not exists
    prod_dbt_cloud_costs_wh
    warehouse_size=xsmall
    auto_suspend=60
    initially_suspended=true;
grant ownership on warehouse prod_dbt_cloud_costs_wh to role rte;

create warehouse if not exists
    ci_dbt_wh
    warehouse_size=xsmall
    auto_suspend=60
    initially_suspended=true;
grant ownership on warehouse ci_dbt_wh to role rte;

