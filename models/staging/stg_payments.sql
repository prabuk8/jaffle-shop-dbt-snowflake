with source as (

    select * from {{ source('raw_data', 'raw_payments') }}

),

renamed as (

    select
        id as payment_id,
        order_id,
        payment_method,
        amount_usd as payment_amount_usd -- Assuming amount is in dollars
    from source

)

select * from renamed