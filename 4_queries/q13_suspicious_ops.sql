-- Счета с подозрительно большим числом операций за короткий период

create or replace function get_suspicious_product_ids_by_period(
       min_count bigint,
       from_time timestamp,
       to_time timestamp
) returns table (
       product_id bigint,
       operations_count bigint
) language plpgsql
as
$$
begin
    return query
    select op.product_id, count(*) as operations_count from
        operation op join product prod
            on op.product_id = prod.id
                where op.operation_time between from_time and to_time
                    group by op.product_id
                        having count(*) >= min_count;
end;
$$;

select print_msg('q13');
select * from get_suspicious_product_ids_by_period(3, (now() - interval '1 year') :: timestamp, now() :: timestamp);