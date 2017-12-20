t
select
  roars_count.month as month,
  median_roars_count,
  median_admin_sessions_per_hub,
  round((median_roars_count::float) / (median_admin_sessions_per_hub::float),1) as roars_per_admin_session
from 
(
  -- MEDIAN ROARS_COUNT MONTHLY
  select
    distinct occurred_date as month,
    median(roars_count) over (partition by occurred_date) as median_roars_count
  from 
  (
    select 
      to_char(r.occurred_at, 'YYYY-MM') as occurred_date, 
      subdomain,  
      count(r.id) as roars_count
    from roars r
    inner join companies co on r.company_id = co.id
    where coalesce(co.salesforce_id,'') != ''
    and co.subdomain != 'vip'
    group by 1,2
  )
) as roars_count 
join
(
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
) as session_count on roars_count.month = session_count.month
order by 1 asc


-- -- ADOVOCACY ACTS PER HUB/ ADMIN SESSIONS PER HUB, MONTHLY
-- -- median events per hub/ median admin session per hub, monthly
-- select
--   event_count.month as month,
--   median_event_count,
--   median_admin_sessions_per_hub,
--   round((median_event_count::float) / (median_admin_sessions_per_hub::float),1) as events_per_admin_session
-- from 
-- (
--   -- MEDIAN EVENT_COUNT MONTHLY
--   select
--     distinct created_date as month,
--     median(events_count) over (partition by created_date) as median_event_count
--   from 
--   (
--     select 
--       to_char(e.created_at, 'YYYY-MM') as created_date, 
--       subdomain, 
--       count(e.id) as events_count
--     from events e
--     inner join companies co on e.company_id = co.id
--     inner join challenges ch on e.challenge_id = ch.id
--     inner join challenge_types cht on ch.challenge_type_id = cht.id
--     where coalesce(co.salesforce_id,'') != ''
--     and e.type = 'completed_challenge'
--     and cht.name like '%eview%'
--     or cht.name like '%efer%'
--     or cht.name like '%estimon%'
--     or cht.name like '%ase stud%'
--     or cht.name like '%ocial%'
--     or cht.name like '%acebook%'
--     or cht.name like '%inkedin%'
--     or cht.name like '%witter%'
--     or cht.name like '%uora%'
--     and cht.name not like '%Preview%'
--     and co.subdomain != 'vip'
--     group by 1,2
--   )
-- ) as event_count 
-- join
-- (
--   -- MEDIAN ADMIN SESSIONS PER HUB MONTHLY
--   with session_count as
--   (
--     select 
--       to_char(s.created_at, 'YYYY-MM') as created_date, 
--       subdomain, 
--       count(s.id) as sessions_count
--     from session_logs s
--     inner join companies co on s.company_id = co.id
--     inner join contacts c on s.contact_id = c.id
--     where c.type = 'Corporate' and email not like '%influitive%'
--     and coalesce(co.salesforce_id,'') != ''
--     and co.subdomain != 'vip'
--     group by 1,2
--   )
--   select
--     distinct created_date as month,
--     median(sessions_count) over (partition by created_date) as median_admin_sessions_per_hub
--   from session_count
--   where created_date != to_char(getdate(), 'YYYY-MM')
-- ) as session_count on event_count.month = session_count.month
-- order by 1 asc




-- select count(distinct cht.name)
-- from events e
-- join challenges ch on e.challenge_id = ch.id
-- join challenge_types cht on ch.challenge_type_id = cht.id
-- where e.type = 'completed_challenge'
-- and cht.name like '%eview%'
-- or cht.name like '%efer%'
-- or cht.name like '%estimon%'
-- or cht.name like '%ase stud%'
-- or cht.name like '%ocial%'
-- or cht.name like '%acebook%'
-- or cht.name like '%inkedin%'
-- or cht.name like '%witter%'
-- or cht.name like '%uora%'
-- and cht.name not like '%Preview%'