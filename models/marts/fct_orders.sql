{{
  config(
    materialized='table'
  )
}}

with orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (
    -- Use intermediate model for payments
    select * from {{ ref('int_order_payments_aggregated') }}

),

order_payments as (

    select
        o.order_id,
        o.customer_id,
        o.order_date,
        o.status as order_status,
        o.order_amount_usd,

        coalesce(p.total_net_payment_amount_usd, 0) as total_payment_amount_usd,
        coalesce(p.payment_count, 0) as payment_count,

        -- Calculate difference (useful for checking discrepancies)
        o.order_amount_usd - coalesce(p.total_net_payment_amount_usd, 0) as payment_difference_usd

    from orders o
    left join payments p on o.order_id = p.order_id

)

select * from order_payments