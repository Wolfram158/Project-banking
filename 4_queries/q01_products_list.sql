-- Список всех активных вкладов или накопительных счетов конкретного клиента с названием продукта

create or replace function get_all_active_products_by_client_id(
       client_id_param bigint
) returns table (
       client_id bigint,
       product_id bigint,
       product_type product_type
) language plpgsql
as
$$
begin
    return query
    select prod.client_id, prod.id, prod_off.product_type from
        product prod join product_offer prod_off on
            prod.product_offer_id = prod_off.id
                where prod.client_id = client_id_param and prod.is_opened = true;
end;
$$;

create or replace function print_msg(msg text) returns text as $$
begin
    raise notice '%', msg;
    return '';
end;
$$ language plpgsql;

select print_msg('q01');
select * from get_all_active_products_by_client_id(1);