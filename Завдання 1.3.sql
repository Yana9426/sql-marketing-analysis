WITH table1 AS (SELECT fabd.ad_date
, fc.campaign_name  
, fa.adset_name 
, fabd.spend 
, fabd.impressions 
, fabd.reach 
, fabd.clicks 
, fabd.leads 
, fabd.value
, 'facebook' AS media_source
FROM facebook_ads_basic_daily fabd
left JOIN facebook_adset fa 
ON fabd.adset_id = fa.adset_id
LEFT JOIN facebook_campaign fc 
ON fc.campaign_id = fabd.campaign_id
UNION ALL 
SELECT ad_date
, campaign_name
, adset_name
, spend
, impressions
, reach
, clicks
, leads
, value
, 'google' AS media_source
FROM google_ads_basic_daily gabd)
SELECT 
date_trunc('week', ad_date) :: date as week_start
, campaign_name
, sum(value) as weekly_value
FROM table1
group by week_start,campaign_name
HAVING sum(value) > 0
order by 3 desc 
limit 1;