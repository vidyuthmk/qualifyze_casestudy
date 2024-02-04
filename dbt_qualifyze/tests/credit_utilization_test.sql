-- Test for data completeness: Total credits utilized should not exceed total credits allocated
SELECT
    id_organization,
    payment_cycle
FROM
    {{ ref('credit_package_utilization') }}
WHERE
    credits_utilized > total_credits_allocated
