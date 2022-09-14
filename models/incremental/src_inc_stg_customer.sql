{{
    config(
        materialized='view'
    )
}}

select 
    *
from
    {{ ref('stg_customer') }}
order by id
limit 20
-- limit 30
-- limit 40