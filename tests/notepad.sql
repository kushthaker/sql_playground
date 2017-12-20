SELECT
  inactive_tbl.month as month,
  inactive_count,
  active_count,
  joined_count
FROM
(
  -- Inactive, working
  -- Advoctes > Monthly Inactive
  SELECT 
  	TO_CHAR(dateadd(month, 1, contacts.last_activity_date), 'YYYY-MM') AS "month",
  	COUNT(distinct contacts.id) AS "inactive_count"
  FROM contacts
  INNER JOIN companies ON contacts.company_id = companies.id
  WHERE (contacts.type = 'Advocate') 
    AND (companies.id LIKE '%')
    -- AND (companies.subdomain = 'xactly')
  GROUP BY 1
) as "inactive_tbl"
inner join
(
  -- Active, working
  SELECT 
  	TO_CHAR(events.created_at, 'YYYY-MM') AS "month",
  	COUNT(DISTINCT CASE WHEN (((contacts.last_activity_date) >= ((DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ))) AND (contacts.last_activity_date) < ((DATEADD(day,30, DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ) ))))) THEN contacts.id ELSE NULL END) AS "active_count"
  FROM contacts
  INNER JOIN companies ON contacts.company_id = companies.id
  INNER JOIN events ON events.contact_id = contacts.id
  WHERE (contacts.type = 'Advocate')  
  	AND (companies.id LIKE '%')
  	-- AND (companies.subdomain = 'xactly')
  GROUP BY 1
) as "active_tbl" on inactive_tbl.month = active_tbl.month
inner join
(
  -- Joined, working
  SELECT 
  	TO_CHAR(events.created_at, 'YYYY-MM') AS "month",
  	COALESCE(COALESCE( ( SUM(DISTINCT (CAST(FLOOR(COALESCE(CASE WHEN contacts.joined_at IS NOT NULL THEN CASE WHEN (TO_CHAR(events.created_at, 'YYYY-MM')) = (TO_CHAR(contacts.joined_at, 'YYYY-MM'))
  THEN 1 ELSE NULL END
   ELSE NULL END,0)*(1000000*1.0)) AS DECIMAL(38,0))) + CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0)) ) - SUM(DISTINCT CAST(STRTOL(LEFT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0))* 1.0e8 + CAST(STRTOL(RIGHT(MD5(CONVERT(VARCHAR,CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END)),15),16) AS DECIMAL(38,0))) )  / (1000000*1.0), 0), 0) AS "joined_count",
  COUNT(DISTINCT CASE WHEN (((contacts.last_activity_date) >= ((DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ))) AND (contacts.last_activity_date) < ((DATEADD(day,30, DATEADD(day,-29, DATE_TRUNC('day',GETDATE()) ) ))))) THEN contacts.id ELSE NULL END) AS "active_count"
  FROM contacts
  INNER JOIN companies ON contacts.company_id = companies.id
  INNER JOIN events ON events.contact_id = contacts.id  
  WHERE (contacts.type = 'Advocate') 
  	AND (companies.id LIKE '%')	
  	-- AND (companies.subdomain = 'xactly')
  GROUP BY 1
) as "joined_tbl" on inactive_tbl.month = joined_tbl.month
order by 1 asc























