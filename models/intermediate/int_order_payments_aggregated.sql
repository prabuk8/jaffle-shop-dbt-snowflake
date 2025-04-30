with payments as (

    select * from {{ ref('stg_payments') }}

),

aggregated as (

    select
        order_id,
        sum(case when payment_amount_usd >= 0 then payment_amount_usd else 0 end) as total_positive_payment_amount_usd,
        sum(case when payment_amount_usd < 0 then payment_amount_usd else 0 end) as total_negative_payment_amount_usd,
        sum(payment_amount_usd) as total_net_payment_amount_usd,
        count(payment_id) as payment_count
    from payments
    group by 1

)

select * from aggregated