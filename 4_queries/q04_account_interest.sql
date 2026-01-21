-- Сумма начисленных процентов на конкретный счёт за период

create or replace function get_percent_sum_by_product_id_and_period(
       product_id_param bigint,
       from_time timestamp,
       to_time timestamp
) returns table (
       summary numeric
) language plpgsql
as
$$
begin
    return query
    select coalesce(sum(op.sum_value), 0) from
        operation op
            where op.product_id = product_id_param and
                  op.operation_type = 'percent' and
                  op.operation_time between from_time and to_time;
end;
$$;

select print_msg('q04');
select * from get_percent_sum_by_product_id_and_period(1, '2025-01-01', '2026-01-01');
