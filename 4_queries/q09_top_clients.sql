-- Пять клиентов с наибольшим оборотом операций за период

create or replace function get_top_k_clients_by_period_and_turnover(
       k_param bigint default 5,
       from_time timestamp default (now() - interval '1 month'),
       to_time timestamp default now()
) returns table (
       client_id bigint,
       turnover numeric
) language plpgsql
as
$$
begin
    return query
    select c.id, sum(op.sum_value) as turnover from
        operation op join product prod on op.product_id = prod.id
            join client c on c.id = prod.client_id
                where op.operation_time between from_time and to_time
                    group by c.id
                        order by turnover desc
                            limit k_param;
end;
$$;

select print_msg('q09');
select * from get_top_k_clients_by_period_and_turnover();