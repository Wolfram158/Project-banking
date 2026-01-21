create table if not exists client(
    id bigserial,
    first_name varchar(100) not null,
    last_name varchar(100) not null,
    birth_date date not null,
    passport varchar(10) not null unique check (length(passport) = 10),
    phone_number varchar(10) not null unique check (length(phone_number) = 10),
    email varchar(256) not null unique,
    registered_at timestamp not null default now(),
    primary key (id)
);

create type currency as enum ('rub', 'eur', 'usd', 'cny', 'gbp');
create type product_type as enum ('deposit', 'saving');
create type accrual_frequence as enum ('per month', 'per two months', 'per three months', 'per six months', 'per year');

create table if not exists product_offer(
    id bigserial,
    product_type product_type not null,
    basic_currency currency not null,
    accrual_frequence accrual_frequence not null,
    is_active boolean not null,
    min_start_value bigint not null check (min_start_value >= 0),
    max_start_value bigint not null check (max_start_value >= 0),
    primary key (id)
);

create table if not exists product(
    id bigserial,
    client_id bigint not null,
    product_offer_id bigint not null,
    open_time timestamp not null default now(),
    currency currency not null,
    is_opened boolean not null,
    primary key (id),
    constraint fk_clients foreign key (client_id) references client(id) on delete restrict,
    constraint fk_product_offers foreign key (product_offer_id) references product_offer(id) on delete restrict
);

create index if not exists idx_product_client_id_product_offer_id on product(client_id, product_offer_id);

create type operation_type as enum ('deposit', 'withdraw', 'percent');

create table if not exists operation(
    id bigserial,
    product_id bigint not null,
    operation_type operation_type not null,
    operation_time timestamp not null default now(),
    sum_value bigint not null,
    result_balance bigint not null,
    primary key (id),
    constraint fk_products foreign key (product_id) references product(id) on delete restrict
);

create index if not exists idx_operation_product_id on operation(product_id);
create index if not exists idx_operation_time_product_id on operation(operation_time, product_id);

comment on column operation.sum_value is 'Сумма операции в указанной валюте, умноженная на 100';
comment on column operation.result_balance is 'Сумма на счёте (после операции) в указанной валюте, умноженная на 100';

create table if not exists interest_rate_history(
    id bigserial,
    product_offer_id bigint not null,
    start_time timestamp not null default now(),
    interest_rate decimal(4,2) not null,
    primary key (id),
    constraint fk_product_offers foreign key (product_offer_id) references product_offer(id) on delete restrict
);

create index if not exists idx_interest_rate_history_product_offer_id on interest_rate_history(product_offer_id);