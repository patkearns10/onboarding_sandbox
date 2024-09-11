select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,
    amount
from {{ source('stripe', 'payment') }}