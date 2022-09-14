with source_customers as (
    select
        *
    from
        {{ source('shop_data', 'shop_customer') }}
),

final as (
    select
        to_date(d.value:"Date of birth"::string, 'yyyymmdd') as date_of_birth,
        d.value:"First Name"::string as first_name,
        d.value:"Last Name"::string as last_name,
        d.value:"ID"::int as id,
        d.value:"Tile"::string as title
    from
        source_customers,
        lateral flatten(input => json) as d
)

select
    *
from
    final