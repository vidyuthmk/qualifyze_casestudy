{{ config(
    materialized = 'table',
    lable = 'credit_package_utilization'
) }}

WITH credit_usage AS (

    SELECT
        C.id_credit_package,
        C.start_date AS credit_start_date,
        C.end_date AS credit_end_date,
        C.credits_amount,
        C.payment_cycle,
        C.id_subscription,
        C.id_organization,
        r.id_request,
        r.created_date,
        r.signed_date AS request_date
    FROM
        {{ ref('int_data_credit_packages') }} C
        LEFT JOIN {{ ref('int_data_requests') }}
        r
        ON C.id_organization = r.id_organization
        AND r.signed_date BETWEEN C.start_date
        AND C.end_date
),
credit_utilization AS (
    SELECT
        id_organization,
        payment_cycle,
        COUNT(
            DISTINCT id_credit_package
        ) AS total_credit_packages,
        SUM(credits_amount) AS total_credits_allocated,
        COUNT(
            DISTINCT id_request
        ) AS total_requests_after_subscription,
        COUNT(
            DISTINCT CASE
                WHEN request_date >= credit_start_date THEN id_request
            END
        ) AS credits_utilized,
        COUNT(
            DISTINCT CASE
                WHEN request_date >= credit_end_date THEN 0
                ELSE 1
            END
        ) AS subcription_status
    FROM
        credit_usage
    GROUP BY
        id_organization,
        payment_cycle
    ORDER BY
        id_organization
)
SELECT
    *,
    total_credits_allocated - credits_utilized AS unused_credits,
    ROUND((credits_utilized) * 100 / (total_credits_allocated), 2) AS rate_of_usage
FROM
    credit_utilization
