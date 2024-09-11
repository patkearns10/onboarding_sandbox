with orders as  (
 
    select * from {{ ref('stg_jappfle_shop_order' )}}
 
),
 
payments as (
 
    select * from {{ ref('stg_payments') }}
    
),
 
order_payments as (
 
    select
 
        order_id,
        sum(case when status = 'success' then amount end) as amount_usd
 
    from payments
    group by 1
)
,
 
final as (
 
    select
        {{ dbt_utils.generate_surrogate_key(['order_id', 'customer_id'])}} as _pk,
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount_usd, 0) as amount
 
    from orders
    left join order_payments using (order_id)
)
 
select * from final