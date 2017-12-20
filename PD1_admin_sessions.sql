-- MEDIAN ADMIN SESSIONS PER HUB MONTHLY
with session_count as
(
  select 
    to_char(s.created_at, 'YYYY-MM') as created_date, 
    subdomain, 
    count(s.id) as sessions_count
  from session_logs s
  inner join companies co on s.company_id = co.id
  inner join contacts c on s.contact_id = c.id
  where c.type = 'Corporate' and email not like '%influitive%'
  and coalesce(co.salesforce_id,'') != ''
  and co.subdomain != 'vip'
  group by 1,2
)
select
  distinct created_date as month,
  median(sessions_count) over (partition by created_date) as median_admin_sessions_per_hub
from session_count
where created_date != to_char(getdate(), 'YYYY-MM')
order by 1 asc