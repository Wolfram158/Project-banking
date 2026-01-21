-- Рейтинг продуктов по приросту активов за 90 дней

create or replace function get_growth_rating_of_products(
       from_time timestamp default (now() - interval '90 day'),
       to_time timestamp default now()
) returns table (
       product_id bigint,
       growth_value numeric
) language plpgsql
as
$$
begin
    return query
    select op.product_id, sum(op.sum_value) from
        operation op
            where op.operation_time between from_time and to_time
                and op.operation_type = 'percent'
                    group by op.product_id
                        order by sum(op.sum_value) desc;
end;
$$