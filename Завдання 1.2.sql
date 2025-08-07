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
ad_date
, 1.00 * coalesce (sum(value),0) / sum (spend) as romi
FROM table1
GROUP BY ad_date
having  sum(spend) > 0
order by romi desc
limit 5;