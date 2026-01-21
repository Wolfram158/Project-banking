-- Аналитика по каждому клиенту: суммы и количество операций для открытых и заблокированных счетов за октябрь 2025

create or replace function get_accounts_analytics(
       from_time timestamp default '2025-10-01',
       to_time timestamp default '2025-10-31 23:59:59.999999'
) returns table (
       client_id bigint,
       client_name text,
       total_active_balance numeric,
       total_blocked_balance numeric,
       total_active_operation_count bigint,
       total_blocked_operation_count bigint
) language plpgsql
as
$$
begin
    return query
    select cl.id, cl.first_name || ' ' || cl.last_name,
           coalesce(sum(case when prod.status = 'opened' then op.sum_value else 0 end), 0),
           coalesce(sum(case when prod.status = 'blocked' then op.sum_value else 0 end), 0),
           count(case when prod.status = 'opened' then op.id end),
           count(case when prod.status = 'blocked' then op.id end)
        from client cl
            left join product prod on cl.id = prod.client_id
                left join operation op on prod.id = op.product_id
                    group by cl.id, cl.first_name, cl.last_name;
end;
$$