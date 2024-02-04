{{ config(
    materialized = 'table',
    lable = 'raw_data_credit_package'
) }}

WITH src AS(

    SELECT
        *
    FROM
        {{ source(
            'external_source',
            'data_credit_packages'
        ) }}
)
SELECT
    *
FROM
    src
