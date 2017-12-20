-- ADVOCATES JOINED, ACTIVE, RESURRECTED, CHURNED
-- GROWTH RATE ((NEW + RESURRECTED)/CHURNED)
-- RETENTION RATE (ACTIVE / JOINED PREVIOUS)

-- INCOMPLETE


SELECT 
  TO_CHAR(contacts.created_at, 'YYYY-MM') AS "contacts.created_month",
  COUNT(DISTINCT CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END) AS "joined",
  COUNT(DISTINCT CASE WHEN (((contacts.last_activity_date) >= ((DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ))) AND (contacts.last_activity_date) < ((DATEADD(day,30, DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ) ))))) THEN contacts.id ELSE NULL END) AS "active",
  COUNT(DISTINCT CASE WHEN (((contacts.last_activity_date) >= ((DATEADD(day,-90, DATE_TRUNC('day',GETDATE()) ))) AND (contacts.last_activity_date) < ((DATEADD(day,60, DATEADD(day,-90, DATE_TRUNC('day',GETDATE()) ) ))))) THEN contacts.id ELSE NULL END) AS "contacts.inactive_count",
  COUNT(DISTINCT CASE WHEN (contacts.last_activity_date < (DATEADD(day,-30, DATE_TRUNC('day',GETDATE()) ))) THEN contacts.id ELSE NULL END) AS "contacts.churned_count",
  COUNT(DISTINCT contacts.id) AS "contacts.count",
  COUNT(DISTINCT contacts.id) AS "contacts.count_unique",
  (COUNT(DISTINCT contacts.id)) AS "contacts.running_count"
FROM public.session_logs AS session_logs
INNER JOIN companies ON session_logs.company_id = companies.id
INNER JOIN contacts ON session_logs.contact_id = contacts.id
WHERE (contacts.created_at >= TIMESTAMP '2013-05-01') AND (contacts.type = 'Advocate') AND (companies.id LIKE '%')
GROUP BY 1
ORDER BY 1 DESC
LIMIT 500

SELECT 
  TO_CHAR(contacts.created_at, 'YYYY-MM') AS "contacts.created_month",
  COUNT(DISTINCT CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END) AS "joined",
  COUNT(DISTINCT CASE WHEN (((contacts.last_activity_date) >= ((DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ))) AND (contacts.last_activity_date) < ((DATEADD(day,30, DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ) ))))) THEN contacts.id ELSE NULL END) AS "active",
  COUNT(DISTINCT CASE WHEN (contacts.last_activity_date < (DATEADD(day,-30, DATE_TRUNC('day',GETDATE()) ))) THEN contacts.id ELSE NULL END) AS "churned",
  -- COUNT(DISTINCT contacts.id) AS "contacts.count",
  -- COUNT(DISTINCT contacts.id) AS "contacts.count_unique",
  -- (COUNT(DISTINCT contacts.id)) AS "contacts.running_count"
FROM public.session_logs AS session_logs
INNER JOIN companies ON session_logs.company_id = companies.id
INNER JOIN contacts ON session_logs.contact_id = contacts.id
WHERE (contacts.created_at >= TIMESTAMP '2013-05-01') AND (contacts.type = 'Advocate') AND (companies.id LIKE '%')
GROUP BY 1
ORDER BY 1 DESC
LIMIT 500

-- Needs confirmation
SELECT
  to_char(sessions.created_at, 'YYYY-MM') AS created_date,
  -- count(distinct case when contacts.joined_at is not null then contacts.id else null end) as joined_count,
  COUNT(DISTINCT CASE WHEN (((contacts.last_activity_date) >= ((DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ))) AND (contacts.last_activity_date) < ((DATEADD(day,30, DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ) ))))) 
THEN contacts.id ELSE NULL END) AS active_count,
  
  -- COUNT(DISTINCT CASE WHEN (contacts.last_activity_date < (DATEADD(day,-30, DATE_TRUNC('day',GETDATE()) ))) THEN contacts.id ELSE NULL END) AS churned_count
FROM
  session_logs as sessions
INNER JOIN companies ON sessions.company_id = companies.id
INNER JOIN contacts ON sessions.contact_id = contacts.id
WHERE to_char(sessions.created_at, 'YYYY-MM') != to_char(getdate(), 'YYYY-MM')
GROUP BY 1
ORDER BY 1 ASC

SELECT 
  TO_CHAR(session_logs.created_at, 'YYYY-MM') AS "session_logs.created_month",
  COUNT(DISTINCT CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END) AS "contacts.joined_count",
  COUNT(DISTINCT CASE WHEN (((contacts.last_activity_date) >= ((DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ))) AND (contacts.last_activity_date) < ((DATEADD(day,30, DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ) ))))) THEN contacts.id ELSE NULL END) AS "contacts.active_count",
  COUNT(DISTINCT CASE WHEN (contacts.last_activity_date < (DATEADD(day,-90, DATE_TRUNC('day',GETDATE()) ))) THEN contacts.id ELSE NULL END) AS "contacts.churned_count"
FROM public.session_logs AS session_logs
INNER JOIN companies ON session_logs.company_id = companies.id
INNER JOIN contacts ON session_logs.contact_id = contacts.id

WHERE (((companies.salesforce_id) IS NOT NULL AND LENGTH(companies.salesforce_id) <> 0 )) AND (contacts.type = 'Advocate') AND (contacts.joined_at IS NOT NULL) AND (contacts.type != 'Corporate') AND (companies.id LIKE '%')
GROUP BY 1
ORDER BY 1 
LIMIT 500