

  

  









with a as (

    
select
    `order_id`, `customer_id`, `surname`, `givenname`, `first_order_date`, `order_count`, `total_lifetime_value`, `order_value_dollars`, `order_status`, `payment_status`

from `shaped-gravity-358002`.`dbt_bihzen77`.`customer_orders`


),

b as (

    
select
    `order_id`, `customer_id`, `surname`, `givenname`, `first_order_date`, `order_count`, `total_lifetime_value`, `order_value_dollars`, `order_status`, `payment_status`

from `shaped-gravity-358002`.`dbt_bihzen77`.`fct_customer_orders`


),

a_intersect_b as (

    select * from a
    

    intersect distinct


    select * from b

),

a_except_b as (

    select * from a
    

    except distinct


    select * from b

),

b_except_a as (

    select * from b
    

    except distinct


    select * from a

),

all_records as (

    select
        *,
        true as in_a,
        true as in_b
    from a_intersect_b

    union all

    select
        *,
        true as in_a,
        false as in_b
    from a_except_b

    union all

    select
        *,
        false as in_a,
        true as in_b
    from b_except_a

),

summary_stats as (
    select
        in_a,
        in_b,
        count(*) as count
    from all_records

    group by 1, 2
)
-- select * from all_records
-- where not (in_a and in_b)
-- order by order_id,  in_a desc, in_b desc

select
    *,
    round(100.0 * count / sum(count) over (), 2) as percent_of_total

from summary_stats
order by in_a desc, in_b desc




limit 500
/* limit added automatically by dbt cloud */