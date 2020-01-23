with usage as (
  select 
    * 
  from 
    {{ source('snowflake_usage', 'warehouse_metering_history') }}
)

select * from usage