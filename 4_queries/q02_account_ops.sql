-- Все операции по выбранному счёту за период с названием продукта

create or replace function get_all_operations_by_product_id_and_period(
       product_id_param bigint,
       from_time timestamp,
       to_time timestamp
) returns table (
       operation_id bigint,
       operation_type operation_type,
       sum_value bigint,
       result_balance bigint,
       product_id bigint,
       product_type product_type
) language plpgsql
as
$$
begin
    return query
    with prod_op as (
        select prod.client_id, prod.product_offer_id, prod.id as product_id, op.id as operation_id,
            op.operation_type, op.sum_value, op.result_balance from
                operation op join product prod on
                    prod.id = op.product_id
                        where prod.id = product_id_param and op.operation_time between from_time and to_time
        )
    select prod_op.operation_id, prod_op.operation_type, prod_op.sum_value, prod_op.result_balance,
           prod_op.product_id, prod_off.product_type from
               prod_op left join product_offer prod_off on
                   prod_op.product_offer_id = prod_off.id;
end;
$$;

select print_msg('q02');
select * from get_all_operations_by_product_id_and_period(1, '2025-01-01', '2026-03-03');