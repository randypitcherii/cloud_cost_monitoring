with daily_usage as (
  select * from {{ ref('stg_hashmap_snowflake_daily_usage') }}
),

snowflake_rolling_sum_of_usage as (
  select 
    calculated_on, 
    sum(credits_used) over (order by calculated_on rows between 29 preceding and current row) as credits_used_last_30_days 
  from 
    daily_usage 
  order by 
    calculated_on desc 
)

select * from snowflake_rolling_sum_of_usage