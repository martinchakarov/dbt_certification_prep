with int_customer as (
    select
        *
    from
        {{ ref('int_customer') }}
),

final as (
    select
        id,
        first_name || ' ' || last_name as name,
        date_of_birth,
        case when title in ('Mr', 'Mister') then 'M' else 'F' end as gender
    from
        int_customer
)

select
    *
from
    final