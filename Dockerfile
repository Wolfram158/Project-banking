FROM postgres:18

COPY 2_ddl/ddl.sql /docker-entrypoint-initdb.d/02.sql

COPY 3_data/data.sql /docker-entrypoint-initdb.d/04.sql

COPY 4_queries/q01_products_list.sql /docker-entrypoint-initdb.d/06.sql
COPY 4_queries/q02_account_ops.sql /docker-entrypoint-initdb.d/08.sql
COPY 4_queries/q03_interest_history.sql /docker-entrypoint-initdb.d/10.sql
COPY 4_queries/q04_account_interest.sql /docker-entrypoint-initdb.d/12.sql
COPY 4_queries/q05_high_rate_clients.sql /docker-entrypoint-initdb.d/14.sql
COPY 4_queries/q06_total_balance.sql /docker-entrypoint-initdb.d/16.sql
COPY 4_queries/q07_multiple_accounts.sql /docker-entrypoint-initdb.d/18.sql
COPY 4_queries/q08_monthly_ops.sql /docker-entrypoint-initdb.d/20.sql
COPY 4_queries/q09_top_clients.sql /docker-entrypoint-initdb.d/22.sql
COPY 4_queries/q10_products_rate_changes.sql /docker-entrypoint-initdb.d/24.sql
COPY 4_queries/q11_inactive_accounts.sql /docker-entrypoint-initdb.d/26.sql
COPY 4_queries/q12_most_profitable_product.sql /docker-entrypoint-initdb.d/28.sql
COPY 4_queries/q13_suspicious_ops.sql /docker-entrypoint-initdb.d/30.sql
COPY 4_queries/q14_high_transfers.sql /docker-entrypoint-initdb.d/32.sql
COPY 4_queries/q15_products_growth.sql /docker-entrypoint-initdb.d/34.sql
COPY 4_queries/q16_tax_clients.sql /docker-entrypoint-initdb.d/36.sql
COPY 4_queries/q17_withdraw_limits.sql /docker-entrypoint-initdb.d/38.sql

COPY 5_additional_ddl/additional_ddl.sql /docker-entrypoint-initdb.d/40.sql

COPY 6_additional_queries/q18_available_accounts.sql /docker-entrypoint-initdb.d/42.sql
COPY 6_additional_queries/q19_block_accounts.sql /docker-entrypoint-initdb.d/44.sql
COPY 6_additional_queries/q20_accounts_analytics.sql /docker-entrypoint-initdb.d/46.sql

COPY start.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/start.sh

RUN chmod 644 /docker-entrypoint-initdb.d/*.sql