-- MEDIAN CHALLENGES COMPLETED PER ADVOCATE
-- per session not included
-- method 1: totals
select
  to_char(e.created_at, 'YYYY-MM') as created_date,
  count(distinct e.id) as challenges_completed_count,
  count(distinct c.id) as advocates_count,
  (count(distinct e.id)::float / count(distinct c.id)::float) as challenges_completed_per_advocate
from events e
inner join contacts c on e.contact_id = c.id
inner join companies co on e.company_id = co.id
where
  e.created_at < to_char(getdate(), 'YYYY-MM') and
  e.type = 'completed_challenge' and
  c.type = 'Advocate'
group by 1
order by 1 asc
limit 1000


-- MEDIAN CHALLENGES COMPLETED PER ADVOCATE
-- method 2: use medians, take ratio
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
    and c.type = 'Advocate' and
    -- added this line, query not running
    to_char(e.created_at, 'YYYY-MM') != to_char(getdate(), 'YYYY-MM')
  group by 1,2
)
select
  distinct created_date,
  -- median(challenges_completed_count) over (partition by created_date)::float,
  -- median(advocates_count) over (partition by created_date)::float,
  (median(challenges_completed_count) over (partition by created_date)::float) / 
  (median(advocates_count) over (partition by created_date)::float) as median_challenges_completed_per_advocate
from events_advocate_table
order by 1 asc