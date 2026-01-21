-- Продукты, по которым ставка изменялась хотя бы раз за последний год

create or replace function get_product_offer_ids_with_changed_interest_rate_by_period(
       from_time timestamp default (now() - interval '1 year'),
       to_time timestamp default now()
) returns table (
       product_offer_id bigint
) language plpgsql
as
$$
begin
    return query
    select distinct irh.product_offer_id from interest_rate_history irh
        where irh.start_time between from_time and to_time;
end;
$$;

select print_msg('q10');
select * from get_product_offer_ids_with_changed_interest_rate_by_period();