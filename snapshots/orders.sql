{% snapshot orders_snapshot %}

{{
    config(
      target_database='dbt_test',
      target_schema='snapshots',
      unique_key='id',

      strategy='timestamp',
      updated_at='_etl_loaded_date',
    )
}}

select * from {{ source('shop_data', '"ORDER"') }}

{% endsnapshot %}