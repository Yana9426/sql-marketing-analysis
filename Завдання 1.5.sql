with data as(SELECT fabd.ad_date  
, fa.adset_name 
FROM facebook_ads_basic_daily fabd
left JOIN facebook_adset fa 
ON fabd.adset_id = fa.adset_id
LEFT JOIN facebook_campaign fc 
ON fc.campaign_id = fabd.campaign_id
UNION ALL 
SELECT ad_date
, adset_name
FROM google_ads_basic_daily gabd
),
unique_days as (
select ad_date
, adset_name
from data
group by 1,2
),
ranked_days as (
select ad_date
, adset_name
, row_number()over (partition by adset_name order by ad_date) as rn
from unique_days
),
grouped_dates as (
select adset_name
, ad_date
, ad_date - interval '1 day' * rn as group_id
from ranked_days
),
streaks as (
select adset_name
, min(ad_date) as start
, max(ad_date) as end
, count(*) as length
from grouped_dates
group by adset_name, group_id)
select *
from streaks
order by length desc 
limit 1;











