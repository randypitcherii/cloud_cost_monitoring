with usage as (
  select * from {{ ref('stg_hashmap_snowflake_usage') }}
),

daily_usage as (
    select 
      sum(credits_used)             as credits_used, 
      date_trunc('day', start_time) as used_on 
    from usage 
    group by used_on 
    order by used_on desc
)

select * from daily_usage