{{ config(
    materialized = 'table',
    lable = 'raw_data_requests'
) }}

WITH src AS (

    SELECT
        *
    FROM
        {{ source(
            'external_source',
            'data_requests'
        ) }}
)
SELECT
    *
FROM
    src
