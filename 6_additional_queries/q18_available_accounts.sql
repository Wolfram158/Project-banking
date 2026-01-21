-- Вывести все счета клиента, доступные для операций, с суммой операций за октябрь 2025

create or replace function get_all_opened_products_by_client_id(
       client_id_param bigint,
       from_time timestamp default '2025-10-01',
       to_time timestamp default '2025-10-31 23:59:59.999999'
) returns table (
       product_id bigint,
       product_type product_type,
       status product_status,
       sum_value numeric
) language plpgsql
as
$$
begin
    return query
    select op.product_id, prod_off.product_type, prod.status, sum(op.sum_value) from
        operation op join product prod on op.product_id = prod.id
            join product_offer prod_off on prod.product_offer_id = prod_off.id
                where op.operation_time between from_time and to_time and
                      prod.client_id = client_id_param and
                      prod.status = 'opened'
                    group by op.product_id, prod_off.product_type, prod.status;
end;
$$
