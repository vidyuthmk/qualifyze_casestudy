{{ config(
    materialized = 'table',
    lable = 'int_data_request',
    unique_key = 'id_request'
) }}

WITH src AS (

    SELECT
        id_request,
        created_date,
        request_state,
        price_eur,
        signed_date,
        id_audit,
        audit_type,
        audit_confirmation_date,
        customer_name,
        id_organization,
        payment_term_days,
        report_published_date,
        audit_selected_date,
        authorization_requested_date,
        supplier_name,
        supplier_country,
        audited_product
    FROM
        {{ ref('raw_data_requests') }}
)
SELECT
    *
FROM
    src
