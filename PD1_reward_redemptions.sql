-- REDEMPTIONS PER HUB/ CONTACTS_COUNT PER HUB, MONTHLY
-- total redemptions per hub/ total advocates per hub, monthly
-- counting null values as 0
select
  distinct month as month,
  round(median(percent_redeemers) over (partition by month),3) as median_percent_redeemers
from
(
 select
    advocates_tbl.joined_date as month,
    advocates_tbl.subdomain as subdomain,
    isnull(redeemers_count,0) as redeemers,
    advocates_count as total_advocates,
    isnull((redeemers_count::float) / (advocates_count::float),0) as percent_redeemers
  from 
  (
  select 
    to_char(rr.created_at, 'YYYY-MM') as created_date, 
    subdomain, 
    count(distinct rr.contact_id) as redeemers_count
  from reward_redemptions rr
  inner join companies co on rr.company_id = co.id
  where coalesce(co.salesforce_id,'') != ''
  and co.subdomain != 'vip'
  group by 1,2
  ) as redeemers_tbl
  right outer join
  (
  select
    to_char(c.joined_at, 'YYYY-MM') as joined_date,
    subdomain,
    count(c.id) as advocates_count
  from contacts c
  inner join companies co on c.company_id = co.id
  where c.type = 'Advocate'
  and c.joined_at is not null
  and coalesce(co.salesforce_id,'') != ''
  and co.subdomain != 'vip'
  group by 1,2 
  ) as advocates_tbl 
  on redeemers_tbl.created_date = advocates_tbl.joined_date
  and redeemers_tbl.subdomain = advocates_tbl.subdomain
)
order by 1 asc


-- Percent Advocates Redeeming Rewards
-- REDEMPTIONS PER HUB/ CONTACTS_COUNT PER HUB, MONTHLY
-- median redemptions per hub/ median  per hub, monthly
select
  contacts_count.month as month,
  isnull(median_redeemers_count,0) as median_redeemers_count,
  median_advocates_count,
  isnull((median_redeemers_count::float) / (median_advocates_count::float), 0) as percent_redeemers
from
(
    -- MEDIAN REDEMPTIONS_COUNT MONTHLY
  select
    distinct created_date as month,
    median(redeemers_count) over (partition by created_date) as median_redeemers_count
  from 
  (
    select 
      to_char(rr.created_at, 'YYYY-MM') as created_date, 
      subdomain, 
      count(distinct rr.contact_id) as redeemers_count
    from reward_redemptions rr
    inner join companies co on rr.company_id = co.id
    where coalesce(co.salesforce_id,'') != ''
    and co.subdomain != 'vip'
    group by 1,2
  )
) as redeemers_count
right outer join
(
  -- MEDIAN CONTACTS_COUNT MONTHLY
  select
    distinct joined_date as month,
    median(advocates_count) over (partition by joined_date) as median_advocates_count
  from
  (
    select
      to_char(c.joined_at, 'YYYY-MM') as joined_date,
      subdomain,
      count(c.id) as advocates_count
    from contacts c
    inner join companies co on c.company_id = co.id
    where c.type = 'Advocate'
    and c.joined_at is not null
    and coalesce(co.salesforce_id,'') != ''
    and co.subdomain != 'vip'
    group by 1,2 
  )  
) as contacts_count on redeemers_count.month = contacts_count.month
order by 1 asc



-- -- REDEMPTIONS PER HUB/ CONTACTS_COUNT PER HUB, MONTHLY
-- -- total redemptions per hub/ total advocates per hub, monthly
-- select
--   distinct month as month,
--   median(redemptions_per_advocate) over (partition by month)
-- from
-- (
--   select
--     redemptions_tbl.created_date as month,
--     redemptions_tbl.subdomain as subdomain,
--     redemptions_count,
--     advocates_count,
--     (redemptions_count::float) / (advocates_count::float) as redemptions_per_advocate
--   from 
--   (
--   select 
--     to_char(rr.created_at, 'YYYY-MM') as created_date, 
--     subdomain, 
--     count(distinct rr.contact_id) as redemptions_count
--   from reward_redemptions rr
--   inner join companies co on rr.company_id = co.id
--   where coalesce(co.salesforce_id,'') != ''
--   and co.subdomain != 'vip'
--   group by 1,2
--   ) as redemptions_tbl
--   join
--   (
--   select
--     to_char(c.joined_at, 'YYYY-MM') as joined_date,
--     subdomain,
--     count(c.id) as advocates_count
--   from contacts c
--   inner join companies co on c.company_id = co.id
--   where c.type = 'Advocate'
--   and c.joined_at is not null
--   and coalesce(co.salesforce_id,'') != ''
--   and co.subdomain != 'vip'
--   group by 1,2 
--   ) as advocates_tbl 
--   on redemptions_tbl.created_date = advocates_tbl.joined_date
--   right join redemptions_tbl.subdomain = advocates_tbl.subdomain
-- )
-- order by 1 asc











