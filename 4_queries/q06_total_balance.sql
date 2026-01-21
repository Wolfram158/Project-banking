-- Общий объём средств на счетах определённого типа

create or replace function get_sum_balance_by_product_type(
       product_type_param product_type
) returns table (
       summary numeric
) language plpgsql
as
$$
begin
    return query
    select sum(result_balance) from (
        select distinct on (op.product_id)
            op.product_id, op.result_balance from
                operation op join product prod on op.product_id = prod.id
                    join product_offer prod_off on prod.product_offer_id = prod_off.id
                        where prod_off.product_type = product_type_param
                            order by op.product_id, op.operation_time desc
        );
end;
$$;

select print_msg('q06');
select * from get_sum_balance_by_product_type('deposit');