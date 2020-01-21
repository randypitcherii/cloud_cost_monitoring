with raw_costs as (
  select * from {{ source('aws_costs', 'hashmap_aws_costs') }}
)

select * from raw_costs