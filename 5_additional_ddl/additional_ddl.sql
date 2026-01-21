-- Обновление структуры счетов для учета нового состояния 'заблокированный'

create type product_status as enum ('opened', 'closed', 'blocked');

alter table product add column status product_status not null default 'opened';

update product set
    status = case
        when is_opened = true then 'opened' :: product_status
        else 'closed' :: product_status
    end;

alter table product drop column is_opened;

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
        prod.status = 'opened' and
        op.operation_time between (to_time - (days_param || ' day') :: interval) and to_time
);
end;
$$;

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
where prod.client_id = client_id_param and prod.status = 'opened';
end;
$$;

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
                where prod.status = 'opened'
                    order by irh.start_time;
end;
$$