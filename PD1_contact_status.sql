-- This inactive count is inconsistent with the hub.
-- JIRA filed for Gabe: http://jira.internal.influitive.com/browse/REP-124

-- FOR EXPLORE > contacts > events.created month > contacts.joined_count, contacts.active_count, contacts.inactive_count
-- Is Advocate 'Yes' AND Is Joined 'Yes' AND companies Is Valid 'Yes'
-- custom filter: ${companies.subdomain}!="vip"
-- TO VERIFY: companies.subdomain = 'xactly' 
SELECT
  joined_and_active_tbl.month AS "month",
  joined_count,
  active_count,
  inactive_count
FROM
(
  -- joined and active counts
  SELECT 
    TO_CHAR(events.created_at, 'YYYY-MM') AS "month",
    COALESCE(COALESCE( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN contacts.joined_at IS NOT NULL THEN CASE WHEN (TO_CHAR(events.created_at, 'YYYY-MM')) = (TO_CHAR(contacts.joined_at, 'YYYY-MM'))
  THEN 1 ELSE NULL END
   ELSE NULL END,0)*(1000000*1.0)) AS DECIMAL(38,0))) + CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0)) ) - SUM(DISTINCT CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0))) )  / (1000000*1.0), 0), 0) AS "joined_count",
  COUNT(DISTINCT CASE WHEN (((contacts.last_activity_date) >= ((DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ))) AND (contacts.last_activity_date) < ((DATEADD(day,30, DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ) ))))) THEN contacts.id ELSE NULL END) AS "active_count"
  FROM contacts
  INNER JOIN companies ON contacts.company_id = companies.id
  INNER JOIN events ON events.contact_id = contacts.id  
  WHERE (companies.active AND (COALESCE(companies.salesforce_id, '') != ''))  
    AND (contacts.type = 'Advocate')
    AND ((companies.subdomain) != 'vip') 
    AND (companies.id LIKE '%') 
    -- AND (companies.subdomain = 'xactly')
  GROUP BY 1
) AS "joined_and_active_tbl"
INNER JOIN
(
  -- inactive count
  SELECT 
    TO_CHAR(dateadd(month, 1, contacts.last_activity_date), 'YYYY-MM') AS "month",
    COUNT(distinct contacts.id) AS "inactive_count"
  FROM contacts
  INNER JOIN companies ON contacts.company_id = companies.id
  WHERE (companies.active AND (COALESCE(companies.salesforce_id, '') != ''))  
    AND (contacts.type = 'Advocate')
    AND ((companies.subdomain) != 'vip') 
    AND (companies.id LIKE '%') 
    -- AND (companies.subdomain = 'xactly')
  GROUP BY 1
) AS "inactive_tbl" ON joined_and_active_tbl.month = inactive_tbl.month
order by 1 asc


-- -- FOR EXPLORE > session_logs.created month > contacts.joined_count, contacts.active_count, contacts.inactive_count
-- -- Is Advocate 'Yes', Is Joined 'Yes'
-- -- companies Is Valid 'yes'
-- -- custom filter: ${companies.subdomain}!="vip"
-- SELECT 
-- 	TO_CHAR(session_logs.created_at, 'YYYY-MM') AS "session_logs.created_month",
-- 	COUNT(DISTINCT CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END) AS "contacts.joined_count",
-- 	COUNT(DISTINCT CASE WHEN (((contacts.last_activity_date) >= ((DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ))) AND (contacts.last_activity_date) < ((DATEADD(day,30, DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ) ))))) THEN contacts.id ELSE NULL END) AS "contacts.active_count",
-- 	COUNT(DISTINCT CASE WHEN (((contacts.last_activity_date) >= ((DATEADD(day,-90, DATE_TRUNC('day',GETDATE()) ))) AND (contacts.last_activity_date) < ((DATEADD(day,60, DATEADD(day,-90, DATE_TRUNC('day',GETDATE()) ) ))))) THEN contacts.id ELSE NULL END) AS "contacts.inactive_count"
-- FROM public.session_logs AS session_logs
-- INNER JOIN companies ON session_logs.company_id = companies.id
-- INNER JOIN contacts ON session_logs.contact_id = contacts.id
-- WHERE (companies.active AND (COALESCE(companies.salesforce_id, '') != '')) 
-- 	AND (contacts.type = 'Advocate')
-- 	AND ((companies.subdomain) != 'vip') 
-- 	AND (companies.id LIKE '%')
-- GROUP BY 1
-- ORDER BY 1 
-- LIMIT 500

-- SELECT
--   inactive_tbl.month as month,
--   inactive_count,
--   active_count,
--   joined_count
-- FROM
-- (
--   -- Inactive, working
--   -- Advoctes > Monthly Inactive
--   SELECT 
--   	TO_CHAR(dateadd(month, 1, contacts.last_activity_date), 'YYYY-MM') AS "month",
--   	COUNT(distinct contacts.id) AS "inactive_count"
--   FROM contacts
--   INNER JOIN companies ON contacts.company_id = companies.id
--   WHERE (contacts.type = 'Advocate') 
--     AND (companies.id LIKE '%')
--     AND (companies.subdomain = 'xactly')
--   GROUP BY 1
-- ) as "inactive_tbl"
-- inner join
-- (
--   -- Active, working
--   SELECT 
--   	TO_CHAR(events.created_at, 'YYYY-MM') AS "month",
--   	COUNT(DISTINCT CASE WHEN (((contacts.last_activity_date) >= ((DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ))) AND (contacts.last_activity_date) < ((DATEADD(day,30, DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ) ))))) THEN contacts.id ELSE NULL END) AS "active_count"
--   FROM contacts
--   INNER JOIN companies ON contacts.company_id = companies.id
--   INNER JOIN events ON events.contact_id = contacts.id
--   WHERE (contacts.type = 'Advocate')  
--   	AND (companies.id LIKE '%')
--   	AND (companies.subdomain = 'xactly')
--   GROUP BY 1
-- ) as "active_tbl" on inactive_tbl.month = active_tbl.month
-- inner join
-- (
--   -- Joined, working
--   SELECT 
--   	TO_CHAR(events.created_at, 'YYYY-MM') AS "month",
--   	COALESCE(COALESCE( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN contacts.joined_at IS NOT NULL THEN CASE WHEN (TO_CHAR(events.created_at, 'YYYY-MM')) = (TO_CHAR(contacts.joined_at, 'YYYY-MM'))
--   THEN 1 ELSE NULL END
--    ELSE NULL END,0)*(1000000*1.0)) AS DECIMAL(38,0))) + CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0)) ) - SUM(DISTINCT CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0))) )  / (1000000*1.0), 0), 0) AS "joined_count"
--   FROM contacts
--   INNER JOIN companies ON contacts.company_id = companies.id
--   INNER JOIN events ON events.contact_id = contacts.id  
--   WHERE (contacts.type = 'Advocate') 
--   	AND (companies.id LIKE '%')	
--   	AND (companies.subdomain = 'xactly')
--   GROUP BY 1
-- ) as "joined_tbl" on inactive_tbl.month = joined_tbl.month
-- order by 1 asc


-- -- Inactive, working
-- -- Advoctes > Monthly Inactive
-- SELECT 
-- 	TO_CHAR(dateadd(month, 1, contacts.last_activity_date), 'YYYY-MM') AS "month",
-- 	COUNT(distinct contacts.id) AS "inactive_count"
-- FROM contacts
-- INNER JOIN companies ON contacts.company_id = companies.id
-- WHERE (contacts.type = 'Advocate') 
--   AND (companies.id LIKE '%')
--   AND (companies.subdomain = 'xactly')
-- GROUP BY 1

-- -- Active, working
-- SELECT 
-- 	TO_CHAR(events.created_at, 'YYYY-MM') AS "events.created_month",
-- 	COUNT(DISTINCT CASE WHEN (((contacts.last_activity_date) >= ((DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ))) AND (contacts.last_activity_date) < ((DATEADD(day,30, DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ) ))))) THEN contacts.id ELSE NULL END) AS "contacts.active_count"
-- FROM contacts
-- INNER JOIN companies ON contacts.company_id = companies.id
-- INNER JOIN events ON events.contact_id = contacts.id
-- WHERE (contacts.type = 'Advocate')  
-- 	AND (companies.id LIKE '%')
-- 	AND (companies.subdomain = 'xactly')
-- GROUP BY 1

-- -- Joined, working
-- SELECT 
-- 	TO_CHAR(events.created_at, 'YYYY-MM') AS "events.created_month",
-- 	COALESCE(COALESCE( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN contacts.joined_at IS NOT NULL THEN CASE WHEN (TO_CHAR(events.created_at, 'YYYY-MM')) = (TO_CHAR(contacts.joined_at, 'YYYY-MM'))
-- THEN 1 ELSE NULL END
--  ELSE NULL END,0)*(1000000*1.0)) AS DECIMAL(38,0))) + CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0)) ) - SUM(DISTINCT CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0))) )  / (1000000*1.0), 0), 0) AS "contacts.joined_count_by_month"
-- FROM contacts
-- INNER JOIN companies ON contacts.company_id = companies.id
-- INNER JOIN events ON events.contact_id = contacts.id

-- WHERE (contacts.type = 'Advocate') 
-- 	AND (companies.id LIKE '%')	
-- 	AND (companies.subdomain = 'xactly')
-- GROUP BY 1
