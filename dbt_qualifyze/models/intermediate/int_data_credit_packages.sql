{{ config(
    materialized = 'table',
    lable = 'int_data_credit_package',
    unique_key = 'id_credit_package'
) }}

WITH src AS (

    SELECT
        id_credit_package,
        signature_date,
        start_date,
        end_date,
        credits_amount,
        total_value_eur,
        payment_cycle,
        id_subscription,
        id_organization
    FROM
        {{ ref('raw_data_credit_packages') }}
)
SELECT
    *
FROM
    src
