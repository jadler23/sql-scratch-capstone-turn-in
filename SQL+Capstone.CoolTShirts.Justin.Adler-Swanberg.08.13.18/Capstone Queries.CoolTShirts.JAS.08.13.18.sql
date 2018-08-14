SELECT DISTINCT utm_campaign as 'Campaign'
FROM page_visits;

*******************************************************

SELECT DISTINCT utm_source as 'Source'
FROM page_visits;

*******************************************************

SELECT DISTINCT utm_campaign AS 'Campaign', utm_source AS 'Source'
FROM page_visits
ORDER by 1 ASC;

*******************************************************

SELECT DISTINCT page_name as 'Page Name'
FROM page_visits;

*******************************************************

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM first_touch ft
  JOIN page_visits pv
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
)
SELECT ft_attr.utm_source AS 'Source',
       ft_attr.utm_campaign AS 'Campaign',
       count(*) AS 'First Touches'
FROM ft_attr
GROUP BY 2,1;
ORDER BY 3

*******************************************************

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source AS 'Source',
       lt_attr.utm_campaign AS 'Campaign',
       count(*) AS 'Last Touches'
FROM lt_attr
GROUP BY 2,1
ORDER BY 3 DESC;

*******************************************************

SELECT page_name AS 'Page Name', COUNT(*) AS 'Visits'
FROM page_visits
WHERE page_name = '4 - purchase';

*******************************************************

WITH last_touch AS (
    SELECT user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.last_touch_at,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_campaign AS 'Campaign', lt_attr.page_name AS 'Page Name',
       COUNT(*) AS 'Last Touches'
FROM lt_attr
WHERE page_name = '4 - purchase'
GROUP BY 2,1
ORDER BY 3 DESC;
