{{ config(
    materialized = 'table',
    lable = 'subscription_insights'
) }}

WITH customer_subscription AS (

    SELECT
        r.id_organization,
        r.id_request,
        r.created_date,
        r.request_state,
        r.price_eur,
        r.signed_date,
        r.id_audit,
        r.audit_type,
        r.audit_confirmation_date,
        r.customer_name,
        r.payment_term_days,
        r.report_published_date,
        r.audit_selected_date,
        r.authorization_requested_date,
        r.supplier_name,
        r.supplier_country,
        r.audited_product,
        C.signature_date,
        C.start_date,
        C.end_date,
        C.credits_amount,
        C.total_value_eur,
        C.payment_cycle
    FROM
        {{ ref('int_data_requests') }}
        r
        LEFT JOIN {{ ref('int_data_credit_packages') }} C
        ON r.id_organization = C.id_organization
        AND r.created_date BETWEEN C.start_date
        AND C.end_date
)
SELECT
    id_organization,
    customer_name,
    payment_cycle,
    COUNT(
        DISTINCT id_request
    ) AS total_requests,
    COUNT(
        DISTINCT id_audit
    ) AS total_audits,
    AVG(credits_amount) AS avg_credits_per_request,
    AVG(total_value_eur) AS avg_value_eur_per_request,
    MIN(audit_confirmation_date) AS earliest_audit_confirmation,
    MAX(audit_confirmation_date) AS latest_audit_confirmation,
    COUNT(
        DISTINCT CASE
            WHEN request_state = 'REPORT_AVAILABLE' THEN id_request
        END
    ) AS completed_audits,
    SUM(credits_amount) AS total_credits_in_package
FROM
    customer_subscription
GROUP BY
    id_organization,
    customer_name,
    payment_cycle
