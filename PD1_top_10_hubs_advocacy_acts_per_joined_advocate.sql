-- LEADERBOARD QUERY, top 10 hubs
-- (count of roars in last week) / (total advocates)
select  
	co.name, 
	count(distinct case when (r.occurred_at > dateadd(day, -7, getdate())) then r.id else null end) as roars_count,
	count(distinct c.id) as advocates_count,
	round((count(distinct case when (r.occurred_at > dateadd(day, -7, getdate())) then r.id else null end) / count(distinct c.id)::float),1) as roars_per_advocate 
from roars r
inner join companies co on r.company_id = co.id
inner join contacts c on r.contact_id = c.id
where c.type = 'Advocate'
and c.joined_at is not null
and coalesce(co.salesforce_id,'') != ''
and co.subdomain != 'vip'
group by 1
having count(distinct case when (r.occurred_at > dateadd(day, -7, getdate())) then r.id else null end) > 1
order by 4 desc
limit 10

-- -- LEADERBOARD QUERY, top 10 hubs
-- -- (count of events in last week) / (total advocates)
-- select  
-- 	co.name, 
-- 	-- count(distinct case when (e.created_at > dateadd(day, -7, getdate())) then e.id else null end) as events_count,
-- 	-- count(distinct c.id) as advocates_count,
-- 	round((count(distinct case when (e.created_at > dateadd(day, -7, getdate())) then e.id else null end) / count(distinct c.id)::float),1) as events_per_advocate 
-- from events e
-- inner join companies co on e.company_id = co.id
-- inner join contacts c on e.contact_id = c.id
-- where c.type = 'Advocate'
-- and c.joined_at is not null
-- and coalesce(co.salesforce_id,'') != ''
-- and co.subdomain != 'vip'
-- group by 1
-- having count(distinct case when (e.created_at > dateadd(day, -7, getdate())) then e.id else null end) > 1
-- order by 2 desc
-- limit 10

-- -- LEADERBOARD QUERY, top 10 hubs
-- -- (count of events in last week) / (total advocates)
-- -- Using manual filtering
-- select  
-- 	co.name, 
-- 	-- count(distinct case when (e.created_at > dateadd(day, -7, getdate())) then e.id else null end) as events_count,
-- 	-- count(distinct c.id) as advocates_count,
-- 	round((count(distinct case when (e.created_at > dateadd(day, -7, getdate())) then e.id else null end) / count(distinct c.id)::float),1) as events_per_advocate 
-- from events e
-- inner join companies co on e.company_id = co.id
-- inner join contacts c on e.contact_id = c.id
-- where c.type = 'Advocate'
-- and c.joined_at is not null
-- and coalesce(co.salesforce_id,'') != ''
-- and co.subdomain != 'vip'
-- and e.type = 'completed_challenge'
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
-- group by 1
-- having count(distinct case when (e.created_at > dateadd(day, -7, getdate())) then e.id else null end) > 1
-- order by 2 desc
-- limit 10

