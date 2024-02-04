{{ config(
    materialized = 'table',
    lable = 'customer_enggagement'
) }}

WITH customer_transition AS (

    SELECT
        r.id_organization,
        CASE
            WHEN C.id_organization IS NOT NULL THEN 'Subscription'
            ELSE 'Transactional'
        END AS customer,
        MAX(
            r.created_date
        ) AS last_request_date
    FROM
        {{ ref('int_data_requests') }}
        r
        LEFT JOIN main_raw.raw_data_credit_packages C
        ON r.id_organization = C.id_organization
        AND r.created_date BETWEEN C.start_date
        AND C.end_date
    GROUP BY
        1,
        2
)
SELECT
    id_organization,
    customer,
    last_request_date
FROM
    customer_transition
WHERE
    last_request_date >= CURRENT_DATE - INTERVAL '1 YEAR'
