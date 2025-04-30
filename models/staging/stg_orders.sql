with source as (

    select * from {{ source('raw_data', 'raw_orders') }}

),

renamed as (

    select
        id as order_id,
        user_id as customer_id,
        order_date::date as order_date, -- Cast to date
        status,
        amount_usd as order_amount_usd -- Assuming amount is in dollars
        -- Example Usage of Macro (if amount was in cents):
        -- {{ cents_to_dollars('amount_cents_column') }} as order_amount_usd
    from source

)

select * from renamed