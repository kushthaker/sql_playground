-- MEDIAN CHALLENGES CREATED PER HUB MONTHLY
with challenge_counts as 
(
  select
    to_char(ch.created_at, 'YYYY-MM') as created_date,
    subdomain,
    count(ch.id) as challenges_count
  from challenges ch
  join companies co on ch.company_id = co.id
  where coalesce(co.salesforce_id,'') != ''
  and co.subdomain != 'vip'
  group by 1,2
)
select
  distinct created_date as month,
  median(challenges_count) over (partition by created_date) as median_challenges_created_per_hub
from challenge_counts
where created_date != to_char(getdate(), 'YYYY-MM')
order by 1 asc

