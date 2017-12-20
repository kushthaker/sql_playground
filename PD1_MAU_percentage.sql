-- FOR EXPLORE > Sessions Logs.created month > Contacts Count, Contacts Joined Count
-- Is Advocate 'Yes' AND Is Joined 'Yes' AND companies Is Valid 'Yes'
-- custom filter: ${companies.subdomain}!="vip"
-- running_total(${contacts.joined_count}) as running_joined_count
-- ${contacts.count} / ${running_joined_count} as MAU, Percent (1)
-- Y Axis > Maximum Value == .3
SELECT 
	TO_CHAR(session_logs.created_at, 'YYYY-MM') AS "session_logs.created_month",
	COUNT(DISTINCT contacts.id) AS "contacts.count",
	COUNT(DISTINCT CASE WHEN contacts.joined_at IS NOT NULL THEN contacts.id ELSE NULL END) AS "contacts.joined_count"
FROM public.session_logs AS session_logs
INNER JOIN companies ON session_logs.company_id = companies.id
INNER JOIN contacts ON session_logs.contact_id = contacts.id
WHERE (companies.active AND (COALESCE(companies.salesforce_id, '') != '')) 
	AND (contacts.type = 'Advocate') 
	AND (contacts.joined_at IS NOT NULL)
	AND ((companies.subdomain) != 'vip') 
	AND (companies.id LIKE '%')
GROUP BY 1
ORDER BY 1



