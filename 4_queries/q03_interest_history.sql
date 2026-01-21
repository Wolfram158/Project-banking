-- Хронологическая история изменений процентной ставки для продуктов с активными счетами

create or replace function get_history_of_interest_rate_for_active_products(
) returns table (
       product_offer_id bigint,
       start_time timestamp,
       interest_rate decimal
) language plpgsql
as
$$
begin
    return query
    select irh.product_offer_id, irh.start_time, irh.interest_rate from product prod
        join product_offer prod_off on prod.product_offer_id = prod_off.id
            join interest_rate_history irh on prod_off.id = irh.product_offer_id
                where prod.is_opened = true
                    order by irh.start_time;
end;
$$;

select print_msg('q03');
select * from get_history_of_interest_rate_for_active_products();