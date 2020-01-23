// prehook to generate a fresh sequence for building a proper daily_usage table
{{
  config(
    pre_hook="CREATE OR REPLACE SEQUENCE {{target.database}}.{{this.schema}}.DAILY_USAGE_SEQ START=0 INCREMENT=1"
  )
}}

with usage as (
  select * from {{ ref('stg_hashmap_snowflake_usage') }}
),

reported_usage_date_range as (
  select
    min(start_time)        as min_date,
    max(start_time)        as max_date
  from
    usage
),

filler_daily_usage as (
  select
    0 as credits_used,
    dateadd(
      day, -{{target.database}}.{{this.schema}}.DAILY_USAGE_SEQ.nextval, current_timestamp
    ) as start_time
  from
    table(generator(rowcount => 1000)) // this will break in the future
  where
    start_time >= (select min_date from reported_usage_date_range) and
    start_time <= (select max_date from reported_usage_date_range)
),

combined_usage as (
  select usage.credits_used, usage.start_time from usage
  union all 
  select fdu.credits_used, fdu.start_time from filler_daily_usage fdu
),

daily_usage as (
    select 
      sum(credits_used)                   as credits_used, 
      date_trunc('day', start_time)::date as calculated_on 
    from 
      combined_usage 
    group by 
      calculated_on 
    order by 
      calculated_on desc
)

select * from daily_usage