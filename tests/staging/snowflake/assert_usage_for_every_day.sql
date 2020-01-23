{{ config(severity='warn') }}

with data as (
  select 
    count(*)                     as num_rows, 
    min(calculated_on)           as first_date, 
    max(calculated_on)           as last_date, 
    (last_date - first_date) + 1 as num_days
  from 
    {{ ref('stg_hashmap_snowflake_daily_usage') }}
),

validation as (
  select 
    *
  from 
    data
  where 
    num_rows != num_days
)

select * from validation
