-- Клиенты с более чем одним вкладом или счётом

create or replace function get_client_ids_with_multiple_accounts(
       variadic product_types product_type[] default array['saving' :: product_type, 'deposit' :: product_type]
) returns table (
       client_id bigint
) language plpgsql
as
$$
begin
    return query
    select prod.client_id from product prod
        join product_offer prod_off on prod.product_offer_id = prod_off.id
            where prod_off.product_type = any(product_types)
                group by prod.client_id
                    having count(prod.client_id) > 1;
end;
$$;

select print_msg('q07');
select * from get_client_ids_with_multiple_accounts();