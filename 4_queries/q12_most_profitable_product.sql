-- Для каждого клиента определить наиболее прибыльный продукт

create
or replace function get_most_profitable_product_for_each_client(
) returns table (
       client_id bigint,
       product_id bigint,
       sum_value numeric
) language plpgsql
as
$$
begin
  return query
  select distinct on (prod.client_id) prod.client_id, prod.id, sum(op.sum_value) as sum_value
      from
          product prod join operation op on prod.id = op.product_id
      where op.operation_type = 'percent'
      group by prod.client_id, prod.id
      order by prod.client_id, sum_value desc;
end;
$$;