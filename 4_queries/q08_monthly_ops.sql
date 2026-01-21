-- Количество операций за последний месяц по каждому клиенту

create or replace function get_operations_count_for_each_client(
       from_time timestamp default (now() - interval '1 month'),
       to_time timestamp default now()
) returns table (
       client_id bigint,
       operations_count bigint
) language plpgsql
as
$$
begin
    return query
    select prod.client_id, count(*) from
        operation op join product prod on op.product_id = prod.id
            where op.operation_time between from_time and to_time
                group by prod.client_id;
end;
$$;

select print_msg('q08');
select * from get_operations_count_for_each_client();