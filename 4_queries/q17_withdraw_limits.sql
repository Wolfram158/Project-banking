-- Клиенты с суммой снятий свыше 1000000 руб. за месяц

create or replace function get_clients_by_min_value_of_withdraw_and_period(
       min_total_value_of_withdraw bigint,
       min_value_of_withdraw_to_increment_op_counter bigint,
       from_time timestamp default (now() - interval '1 month'),
       to_time timestamp default now()
) returns table (
       client_id bigint,
       withdraw_total numeric,
       operation_count bigint
) language plpgsql
as
$$
begin
    return query
    select prod.client_id, sum(op.sum_value) as withdraw_total, count(op.id)
        filter (where op.sum_value > min_value_of_withdraw_to_increment_op_counter) from
        operation op join product prod on op.product_id = prod.id
            join product_offer prod_off on prod.product_offer_id = prod_off.id
                where prod_off.product_type = 'saving' and
                      op.operation_time between from_time and to_time and
                          op.operation_type = 'withdraw'
                              group by prod.client_id
                                  having sum(op.sum_value) > min_total_value_of_withdraw
                                      order by withdraw_total desc;
end;
$$