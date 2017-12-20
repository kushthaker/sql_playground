select distinct ct.id, first_name, last_name, email
from session_logs s
join companies co on s.company_id = co.id
join contacts ct on s.contact_id = ct.id
where (co.active AND (COALESCE(co.salesforce_id, '') != ''))
and s.platform = 'maven'
and ct.type = 'Advocate'
and ct.joined_at is not null
and co.subdomain = 'staples'