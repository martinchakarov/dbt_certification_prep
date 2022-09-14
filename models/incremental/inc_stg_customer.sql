{{
    config(
        materialized='incremental',
        unique_key='id'
    )
}}

select
    *
from
    {{ ref('src_inc_stg_customer') }}

{% if is_incremental() %}
where id > (select max(id) from {{ this }})
{% endif %}