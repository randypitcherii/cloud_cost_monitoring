with data as (
  select 
    count(*) as num_rows, 
    min(used_on)::date as first_date, 
    max(used_on)::date as last_date, 
    (last_date - first_date) + 1 as num_days
  from {{ ref('stg_hashmap_snowflake_daily_usage') }}
),

validation as (
  select *
  from data
  where num_rows != num_days
)

select * from validation
