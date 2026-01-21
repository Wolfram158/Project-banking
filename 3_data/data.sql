insert into client (first_name, last_name, birth_date, passport, phone_number, email)
values ('Sam', 'Sidorov', '2019-10-11', '4017834002', '9172291923', 'sam-sidorov@yandex.com'),
       ('John', 'Samov', '2014-04-03', '4015234353', '9501998228', 'johny12345@google.ru'),
       ('Sidor', 'Johnov', '2008-08-20', '4013123456', '9644063752', 'postgresql@info.ru'),
       ('Binder', 'Parcelov', '2008-02-28', '4013012345', '9943042353', 'android229@google.team'),
       ('Ktor', 'Springov', '2011-11-12', '4014879235', '9213781915', 'spring-bot227@autumn.com');

insert into product_offer (product_type, basic_currency, accrual_frequence, is_active, min_start_value,
                                 max_start_value)
values ('saving', 'rub', 'per month', true, 100, 1000000000),
       ('saving', 'rub', 'per month', true, 100, 1000000000),
       ('deposit', 'rub', 'per year', true, 100, 8000000000),
       ('deposit', 'rub', 'per three months', true, 100, 100000000);

insert into product (client_id, product_offer_id, open_time, currency, is_opened)
values (1, 2, to_timestamp(1764162377), 'rub', true),
       (1, 3, to_timestamp(1764162377), 'rub', true),
       (2, 3, to_timestamp(1764162377), 'rub', true),
       (2, 4, to_timestamp(1764162377), 'rub', true),
       (3, 1, to_timestamp(1764162377), 'rub', true);

insert into operation (product_id, operation_type, operation_time, sum_value, result_balance)
values (5, 'deposit', to_timestamp(1764162377), 123000, 123000),
       (2, 'deposit', to_timestamp(1764162377), 256000000, 256000000),
       (3, 'deposit', to_timestamp(1764162377), 23800000, 23800000),
       (4, 'deposit', to_timestamp(1764162377), 34700000, 34700000),
       (1, 'deposit', to_timestamp(1764162377), 68000000, 68000000);

insert into operation (product_id, operation_type, operation_time, sum_value, result_balance)
values (5, 'percent', to_timestamp(1766754377), 8610, 131610),
       (1, 'percent', to_timestamp(1766754377), 13600000, 81600000),
       (3, 'deposit', to_timestamp(1766774377), 100000, 8000100000),
       (5, 'deposit', to_timestamp(1766794377), 10000, 141610),
       (2, 'deposit', to_timestamp(1766894377), 100000, 256100000);

insert into interest_rate_history (product_offer_id, start_time, interest_rate)
values (1, to_timestamp(1764162377), 7),
       (2, to_timestamp(1764162377), 20),
       (3, to_timestamp(1764162377), 3),
       (4, to_timestamp(1764162377), 2),
       (1, to_timestamp(1768894377), 0.1),
       (2, to_timestamp(1769894377), 30),
       (3, to_timestamp(1771894377), 5),
       (3, to_timestamp(1771899377), 0.5);

select * from client;
select * from product;
select * from product_offer;
select * from interest_rate_history;
select * from operation;