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
, monthly_reach as (
SELECT date_trunc('month', ad_date) :: date as ad_month
, campaign_name
, SUM(reach) AS monthly_reach
FROM table1
where campaign_name is not null
group by ad_month,campaign_name)
, reach_with_diff AS (
SELECT 
    campaign_name,
    ad_month,
    monthly_reach,
    LAG(monthly_reach,1) OVER (PARTITION BY campaign_name ORDER BY ad_month) AS prev_month_reach
  FROM monthly_reach)
SELECT 
  campaign_name,
  ad_month,
  monthly_reach,
  prev_month_reach,
  (monthly_reach - prev_month_reach) AS reach_diff
FROM reach_with_diff
WHERE prev_month_reach IS NOT NULL
ORDER BY reach_diff DESC
LIMIT 1;





-- monthly_reach  -сумую reach(охоплення) по кампаніях та місяцях
-- reach_with_diff - порівнюю з попереднім місяцем(LAG)
-- останній SElect  -рахую різницю, сортую і повертаю найбільший приріст