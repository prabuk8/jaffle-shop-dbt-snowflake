-- Test that the total payment amount for completed/shipped orders isn't negative
-- Refunds might make it zero, but not negative in total for non-returned orders.
select
    order_id,
    sum(total_payment_amount_usd) as total_amount
from {{ ref('fct_orders') }}
where order_status in ('completed', 'shipped') -- Only check non-returned orders
group by 1
having sum(total_payment_amount_usd) < 0