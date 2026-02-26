with customer as(
    select * from {{ref('raw_customers')}}
),
orders as(
    select  * from {{ref('raw_orders')}}
),
payment as(
    select * from {{ref('raw_payments')}}
),
final as(
    select 
    c.id,
    c.first_name,
    c.last_name,
    o.first_order,
    o.most_recent_order,
    o.number_of_orders,
    p.total as customer_lifetime_value from 
    customer c 
    left join 
    (select user_id ,sum(amount)as total from  orders o left join  payment p on o.id=p.order_id group by user_id) p
    on c.id=p.user_id
    left join 
    (select USER_ID,min(order_date) as first_order,max(id) as most_recent_order,count(id) as number_of_orders from orders group by user_id) o
    on o.user_id=c.id
)
select * from final