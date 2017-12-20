-- MEDIAN CHALLENGES COMPLETED PER ADVOCATE
with events_advocate_table as
(
  select
    to_char(e.created_at, 'YYYY-MM') as created_date,
    subdomain,
    count(distinct e.id) as challenges_completed_count,
    count(distinct c.id) as advocates_count
  from events e
  inner join contacts c on e.contact_id = c.id
  inner join companies co on e.company_id = co.id
  where
    e.type = 'completed_challenge'
    and c.type = 'Advocate'
    and coalesce(co.salesforce_id,'') != ''
    and to_char(e.created_at, 'YYYY-MM') != to_char(getdate(), 'YYYY-MM')
    and co.subdomain != 'vip'
  group by 1,2
)
select
  distinct created_date,
  median(challenges_completed_count) over (partition by created_date)::float as median_challenges_completed,
  median(advocates_count) over (partition by created_date)::float as median_advocates,
  round((median(challenges_completed_count) over (partition by created_date)::float) / 
  (median(advocates_count) over (partition by created_date)::float),1) as median_challenges_completed_per_advocate
from events_advocate_table
order by 1 asc