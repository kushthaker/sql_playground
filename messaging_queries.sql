-- RUN THIS QUERY IN SQLRUNNER

SELECT
	engagements_table.date,
	engagements_table.contact_count AS "total_engaged_contacts",
	engagements_table.contacts_sent_message AS "contacts_sent_message",
	engagements_table.total_engagements AS "total_engagements",
	engagements_table.messages_sent AS "messages_sent",
	sessions_table.unique_logins AS "unique_contact_logins",
	sessions_table.sessions AS "sessions"
FROM
(
SELECT 
	TO_CHAR(engagements.occurred_at, 'YYYY-MM-DD') AS "date",
	COUNT(DISTINCT CASE WHEN engagements.type = 'message_sent' THEN engagements.contact_id ELSE NULL END) AS "contacts_sent_message",
	COUNT(DISTINCT engagements.contact_id) AS "contact_count",
	COUNT(engagements.id) AS "total_engagements",
	COUNT(DISTINCT CASE WHEN engagements.type = 'message_sent' THEN engagements.id ELSE NULL END) as "messages_sent"
FROM engagements
INNER JOIN companies ON engagements.company_id = companies.id
INNER JOIN contacts ON contacts.company_id = companies.id AND engagements.contact_id = contacts.id
WHERE ((((engagements.occurred_at) >= (TIMESTAMP '2016-11-20') AND (engagements.occurred_at) < (TIMESTAMP '2016-12-24')))) 
  AND (companies.subdomain IN ('asigra', 'dashlane', 'epn', 'getcake', 'pgisales', 'vif', 'namely', 'zeroturnaround', 'infusionsoft', 'brainshark', 'bmc', 'netbase', 'navigateprepared', 'looker', 'calabrio', 'bbchampions', 'aerohive', 'vip', 'tintri', 'emc', 'apprenda', 'semrush', 'staples', 'boxx', 'smarttech', 'boomtown', 'dundas', 'thepredictiveindex', 'freshbooks', 'dellemc', 'kinaxis', 'itominsiders', 'arizonasunshine', 'mavenlink', 'riverbed', 'tagetik', 'forcepoint', 'herok12', 'rosettastone', 'renaissance', 'terrapass', 'payscale', 'touchbistro', 'perforce', 'selectinternational', 'biznet', 'apriori', 'procore', 'crimsonhexagon', 'vht', 'ibmblueaccess', 'verint', 'oraclesocial', 'qlik', 'ecobee', 'wrike', 'hpe', 'clinicient', 'alfresco', 'sas')) 
  AND (contacts.type = 'Advocate')
  AND (companies.active AND (COALESCE(companies.salesforce_id, '') != ''))
  AND (companies.id LIKE '%')
GROUP BY 1
) AS engagements_table
INNER JOIN
(
	SELECT 
		TO_CHAR(session_logs.created_at, 'YYYY-MM-DD') AS "date",
		COUNT(DISTINCT contacts.id) AS "unique_logins",
		COUNT(*) AS "sessions"
	FROM public.session_logs AS session_logs
	INNER JOIN companies ON session_logs.company_id = companies.id
	INNER JOIN contacts ON contacts.company_id = companies.id AND session_logs.contact_id = contacts.id
	WHERE 
		((((session_logs.created_at) >= (TIMESTAMP '2016-11-20') AND (session_logs.created_at) < (TIMESTAMP '2016-12-24')))) 
		AND (companies.subdomain IN ('asigra', 'dashlane', 'epn', 'getcake', 'pgisales', 'vif', 'namely', 'zeroturnaround', 'infusionsoft', 'brainshark', 'bmc', 'netbase', 'navigateprepared', 'looker', 'calabrio', 'bbchampions', 'aerohive', 'vip', 'tintri', 'emc', 'apprenda', 'semrush', 'staples', 'boxx', 'smarttech', 'boomtown', 'dundas', 'thepredictiveindex', 'freshbooks', 'dellemc', 'kinaxis', 'itominsiders', 'arizonasunshine', 'mavenlink', 'riverbed', 'tagetik', 'forcepoint', 'herok12', 'rosettastone', 'renaissance', 'terrapass', 'payscale', 'touchbistro', 'perforce', 'selectinternational', 'biznet', 'apriori', 'procore', 'crimsonhexagon', 'vht', 'ibmblueaccess', 'verint', 'oraclesocial', 'qlik', 'ecobee', 'wrike', 'hpe', 'clinicient', 'alfresco', 'sas')) 
		AND (companies.active AND (COALESCE(companies.salesforce_id, '') != '')) 
		AND (contacts.type = 'Advocate') 
		AND (companies.id LIKE '%')
	GROUP BY 1
) AS sessions_table ON engagements_table.date = sessions_table.date
ORDER BY 1 ASC





---- TEST WITH ONLY 3 SUBDOMAINS

https://looker.internal.influitive.com/explore/majority_report/engagements?fields=engagements.contact_count,engagements.count,engagements.occurred_date&f[companies.subdomain]=infusionsoft%2Cbrainshark%2Cbmc&f[companies.valid]=Yes&f[contacts.is_advocate]=Yes&f[engagements.occurred_date]=2016%2F11%2F20+to+2016%2F12%2F24&f[engagements.type]=message%5E_sent&sorts=engagements.occurred_date&limit=500&column_limit=50&query_timezone=America%2FToronto&vis=%7B%7D&filter_config=%7B%22companies.subdomain%22%3A%5B%7B%22type%22%3A%22%3D%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22infusionsoft%2Cbrainshark%2Cbmc%22%7D%2C%7B%7D%5D%2C%22id%22%3A2%2C%22error%22%3Afalse%7D%5D%2C%22companies.valid%22%3A%5B%7B%22type%22%3A%22is%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22Yes%22%7D%2C%7B%7D%5D%2C%22id%22%3A0%7D%5D%2C%22contacts.is_advocate%22%3A%5B%7B%22type%22%3A%22is%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22Yes%22%7D%2C%7B%7D%5D%2C%22id%22%3A1%7D%5D%2C%22engagements.occurred_date%22%3A%5B%7B%22type%22%3A%22between%22%2C%22values%22%3A%5B%7B%22date%22%3A%222016-11-20T14%3A43%3A30.562Z%22%2C%22unit%22%3A%22day%22%2C%22tz%22%3Atrue%2C%22constant%22%3A%227%22%7D%2C%7B%22date%22%3A%222016-12-24T14%3A43%3A30.562Z%22%2C%22unit%22%3A%22day%22%2C%22tz%22%3Atrue%7D%5D%2C%22id%22%3A3%2C%22error%22%3Afalse%7D%5D%2C%22engagements.type%22%3A%5B%7B%22type%22%3A%22%3D%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22message_sent%22%7D%2C%7B%7D%5D%2C%22id%22%3A4%2C%22error%22%3Afalse%7D%5D%7D&show=data%2Cfields%2Cfilter&origin=share-expanded

SELECT 
	TO_CHAR(engagements.occurred_at, 'YYYY-MM-DD') AS "date",
	COUNT(DISTINCT CASE WHEN engagements.type = 'message_sent' THEN engagements.contact_id ELSE NULL END) AS "contacts_sent_message",
	COUNT(DISTINCT engagements.contact_id) AS "contact_count",
	COUNT(engagements.id) AS "total_engagements",
	COUNT(DISTINCT CASE WHEN engagements.type = 'message_sent' THEN engagements.id ELSE NULL END) as "messages_sent"
FROM engagements
INNER JOIN companies ON engagements.company_id = companies.id
INNER JOIN contacts ON contacts.company_id = companies.id AND engagements.contact_id = contacts.id
WHERE ((((engagements.occurred_at) >= (TIMESTAMP '2016-11-20') AND (engagements.occurred_at) < (TIMESTAMP '2016-12-24')))) 
  AND (companies.subdomain IN ('infusionsoft', 'brainshark', 'bmc')) 
  AND (contacts.type = 'Advocate')
  AND (companies.active AND (COALESCE(companies.salesforce_id, '') != ''))
  AND (companies.id LIKE '%')
GROUP BY 1
ORDER BY 1 asc