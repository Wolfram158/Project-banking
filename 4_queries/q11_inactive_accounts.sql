-- Счета без операций дольше указанного количества дней

create or replace function get_product_ids_without_changes_by_period(
       days_param bigint,
       to_time timestamp default now()
) returns table (
       product_id bigint
) language plpgsql
as
$$
begin
    return query
    select prod.id from product prod
        where not exists (
            select 1 from operation op
                where prod.id = op.product_id and
                    prod.is_opened = true and
                    op.operation_time between (to_time - (days_param || ' day') :: interval) and to_time
        );
end;
$$;

select print_msg('q11');
select * from get_product_ids_without_changes_by_period(10);