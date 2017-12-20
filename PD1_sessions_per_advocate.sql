  -- MEDIAN SESSIONS PER ADVOCATE MONTHLY
-- (median count of sessions) / (median count of advocates), monthly
with sessions_advocates_table as
(
  select 
    to_char(session_logs.created_at, 'YYYY-MM') as created_date,
    subdomain,
    count(distinct session_logs.id)::float as sessions_count,
    count(DISTINCT contacts.id)::float as advocates_count
  from session_logs
  left join contacts on session_logs.contact_id = contacts.id
  inner join companies on session_logs.company_id  = companies.id
  where contacts.type = 'Advocate' 
  AND to_char(session_logs.created_at, 'YYYY-MM') != to_char(getdate(), 'YYYY-MM')
  AND session_logs.id IS NOT NULL
  and coalesce(companies.salesforce_id,'') != ''
  and companies.subdomain != 'vip'
  group by 1,2
)
select
  distinct created_date,
  median(sessions_count) over (partition by created_date) as median_sessions_count,
  median(advocates_count) over (partition by created_date) as median_advocates_count,
  round(median(sessions_count) over (partition by created_date)/median(advocates_count) over (partition by created_date),1) as median_sessions_per_advocate
from sessions_advocates_table
order by 1 asc