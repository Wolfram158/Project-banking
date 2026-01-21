-- Клиенты с прибылью выше 250000 руб. и сумма налога 13%

create or replace function get_client_ids_and_tax_by_min_growth_and_period(
       min_value bigint,
       from_time timestamp,
       to_time timestamp default now()
) returns table (
       client_id bigint,
       tax_value numeric
) language plpgsql
as
$$
begin
    return query
    select prod.client_id, 0.13 * sum(op.sum_value) from
        product prod join operation op on
            prod.id = op.product_id
                where op.operation_time between from_time and to_time and
                    op.operation_type = 'percent'
                        group by prod.client_id
                            having sum(op.sum_value) > min_value;
end;
$$