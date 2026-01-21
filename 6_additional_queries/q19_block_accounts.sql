-- Заблокировать счета с суммой операций за октябрь 2025 > 1_000_000 и вывести их

create or replace function block_products_by_min_total_op_sum_and_period(
       min_value bigint,
       from_time timestamp default '2025-10-01',
       to_time timestamp default '2025-10-31 23:59:59.999999'
) returns table (
       product_id bigint,
       product_type product_type,
       status product_status
) language plpgsql
as
$$
begin
    return query
    with block_candidates as (
        select prod.id from operation op
            join product prod on op.product_id = prod.id
                where op.operation_time between from_time and to_time and
                    prod.status = 'opened'
                        group by prod.id
                            having sum(op.sum_value) > min_value
    ),
    updated_products as (
        update product
            set status = 'blocked' where
                product.id in (select id from block_candidates)
                    returning product.id, product.product_offer_id, product.status
    )
    select up.id, prod_off.product_type, up.status from
        updated_products up join product_offer prod_off on
            up.product_offer_id = prod_off.id;
end;
$$