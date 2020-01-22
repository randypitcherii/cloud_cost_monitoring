![](https://github.com/randypitcherii/cloud_cost_monitoring/workflows/Scheduled%20production%20run/badge.svg)
![](https://github.com/randypitcherii/cloud_cost_monitoring/workflows/Production%20deployment%20from%20master/badge.svg)
# Cloud Cost Monitoring
This DBT project contains logic for converting raw cost data loaded from Azure, AWS, and GCP into consumable analytics tables.

Snowflake costs are also gathered from the `ACCOUNT_USAGE` tables.

## Snowflake setup
I used the sql in [snowflake_setup](./snowflake_setup) to create the top level databases, warehouse, and permissions that I use for deploying to Snowflake. This is pretty hashmap-specific, so feel free to use / modify / ignore this. 