 --Plan 
 /* 1)PLAN
	First i try to find how many people come to the website
	Second,How many people interact with website
	Third, How many people order
	Lastly,How many people purchased

	2)PLAN
	Which device people preferred by customers?


	3)PLAN
	Which marketing tool is better paid marketing or content marketing?
	 */

select * from website_sessions

select COUNT(distinct(user_id)) from website_sessions
--People who interact with website are 394.318


select COUNT(distinct(user_id)) from website_sessions where is_repeat_session = 1
--We take attention of 51.270 people

--VALIDATION
select COUNT(distinct(website_session_id)) from website_pageviews
-- 472.871 Rows 

select COUNT(distinct(website_session_id)) from website_sessions
-- 472.871 Rows
-------------------------------------------------------------------------------

select * from website_sessions

select COUNT(distinct(s.user_id)) from website_pageviews v join website_sessions s on s.website_session_id = v.website_session_id 
-- Only 394.318 people came to our website


select COUNT(distinct(s.user_id)) from website_pageviews v join website_sessions s on s.website_session_id = v.website_session_id where v.pageview_url in ('/home','/products','/cart','/shipping','/billing')
-- Only 89.895 people think to order


select COUNT(distinct(s.user_id)) from website_pageviews v join website_sessions s on s.website_session_id = v.website_session_id where v.pageview_url  in ('/lander-1','/lander-2','/lander-3','/lander-4','/lander-5') and v.pageview_url in ('/cart','/billing','/shipping')
-- 335.295 come from advertisement

SELECT COUNT(DISTINCT s.user_id)
FROM website_sessions s
JOIN website_pageviews v ON s.website_session_id = v.website_session_id
WHERE v.pageview_url IN ('/lander-1','/lander-2','/lander-3','/lander-4','/lander-5')
  AND s.user_id IN (
      SELECT DISTINCT s2.user_id
      FROM website_sessions s2
      JOIN website_pageviews v2 ON s2.website_session_id = v2.website_session_id
      WHERE v2.pageview_url IN ('/cart','/billing','/shipping')
  );

--77.159 people from advirtesement think to pay.




select COUNT(distinct(s.user_id)) from orders o join website_sessions s on s.website_session_id=o.website_session_id
-- 31.696 people orders

select * from website_sessions
select * from order_item_refunds
select * from orders
select * from order_items


select COUNT(distinct(order_id)) from orders
--32313

select COUNT(distinct(order_id)) from order_items
--32313

select COUNT(distinct(website_session_id)) from orders
--32.313

select COUNT(distinct(website_session_id)) from website_sessions
--472.871

select * from orders
select * from order_item_refunds
select * from website_sessions
select * from website_pageviews


-----------------------------------------------------------------------

select COUNT(distinct(s.user_id)) from order_items oi 
		join orders o on o.order_id=oi.order_id
		join website_sessions s on s.website_session_id = o.website_session_id
		left join order_item_refunds re on re.order_id = o.order_id where re.order_item_refund_id is null

--30.040 people are buying in the end of this process.





---------------------------------------------------------------------------
--JOINING ALL TABLES

WITH query1 AS (
    SELECT 
        COUNT(DISTINCT user_id) AS ws_ses,
        user_id 
    FROM website_sessions
    GROUP BY user_id
), 
query2 AS (
    SELECT 
        COUNT(DISTINCT s.user_id) AS page_,
        s.user_id 
    FROM website_pageviews v 
    JOIN website_sessions s 
        ON s.website_session_id = v.website_session_id 
    WHERE v.pageview_url in ('/home','/products','/cart','/shipping','/billing')
    GROUP BY s.user_id
),
query3 AS (
    SELECT 
        COUNT(DISTINCT s.user_id) AS orders,
        s.user_id 
    FROM orders o 
    JOIN website_sessions s 
        ON s.website_session_id = o.website_session_id 
    GROUP BY s.user_id
), 
query4 AS (
    SELECT 
        COUNT(DISTINCT s.user_id) AS purchased,
        s.user_id 
    FROM order_items oi 
    JOIN orders o 
        ON o.order_id = oi.order_id 
    JOIN website_sessions s 
        ON s.website_session_id = o.website_session_id
    LEFT JOIN order_item_refunds re 
        ON re.order_id = o.order_id 
    WHERE re.order_item_refund_id IS NULL
    GROUP BY s.user_id
) 
SELECT 
    sum(q1.ws_ses) as Web_directing,
    sum(q2.page_) as Page_interaction,
    sum(q3.orders) as Orders,
    sum(q4.purchased) as Purchased
FROM query1 q1
LEFT JOIN query2 q2 ON q1.user_id = q2.user_id
LEFT JOIN query3 q3 ON q1.user_id = q3.user_id
LEFT JOIN query4 q4 ON q1.user_id = q4.user_id;


--------------------------------------------
--Percentages

WITH query1 AS (
    SELECT 
        COUNT(DISTINCT user_id) AS ws_ses,
        user_id 
    FROM website_sessions
    GROUP BY user_id
), 
query2 AS (
    SELECT 
        COUNT(DISTINCT s.user_id) AS page_,
        s.user_id 
    FROM website_pageviews v 
    JOIN website_sessions s 
        ON s.website_session_id = v.website_session_id 
    WHERE v.pageview_url IN ('/home', '/products', '/cart', '/shipping', '/billing')
    GROUP BY s.user_id
),
query3 AS (
    SELECT 
        COUNT(DISTINCT s.user_id) AS orders,
        s.user_id,
    FROM orders o 
    JOIN website_sessions s 
        ON s.website_session_id = o.website_session_id 
    GROUP BY s.user_id
), 
query4 AS (
    SELECT 
        COUNT(DISTINCT s.user_id) AS purchased,
        s.user_id 
    FROM order_items oi 
    JOIN orders o 
        ON o.order_id = oi.order_id 
    JOIN website_sessions s 
        ON s.website_session_id = o.website_session_id
    LEFT JOIN order_item_refunds re 
        ON re.order_id = o.order_id 
    WHERE re.order_item_refund_id IS NULL
    GROUP BY s.user_id
) 
SELECT 
    SUM(q1.ws_ses) AS Web_directing,
    SUM(q2.page_) AS Page_interaction,
    SUM(q3.orders) AS Orders,
    SUM(q4.purchased) AS Purchased,
    -- Yüzdesel deðiþim hesaplamalarý (ondalýklý hesaplama için CAST kullanýmý)
    100.0 * (CAST(SUM(q2.page_) AS FLOAT) / NULLIF(CAST(SUM(q1.ws_ses) AS FLOAT), 0)) AS Page_interaction_percentage,
    100.0 * (CAST(SUM(q3.orders) AS FLOAT) / NULLIF(CAST(SUM(q2.page_) AS FLOAT), 0)) AS Orders_percentage,
    100.0 * (CAST(SUM(q4.purchased) AS FLOAT) / NULLIF(CAST(SUM(q3.orders) AS FLOAT), 0)) AS Purchased_percentage
FROM query1 q1
LEFT JOIN query2 q2 ON q1.user_id = q2.user_id
LEFT JOIN query3 q3 ON q1.user_id = q3.user_id
LEFT JOIN query4 q4 ON q1.user_id = q4.user_id;


------------------------------------------------------------------------------------
--2)Which device prefferred the most?

WITH query1 AS (
    SELECT 
        user_id, 
        device_type,
        COUNT(distinct(user_id)) AS ws_ses
    FROM website_sessions
    GROUP BY user_id, device_type
), 
query2 AS (
    SELECT 
        s.user_id, 
        COUNT(distinct(s.user_id)) AS page_interaction
    FROM website_pageviews v 
    JOIN website_sessions s 
        ON s.website_session_id = v.website_session_id 
    WHERE v.pageview_url IN ('/home','/products','/cart','/shipping','/billing')
    GROUP BY s.user_id
),
query3 AS (
    SELECT 
        s.user_id, 
        COUNT(distinct(s.user_id)) AS orders
    FROM orders o 
    JOIN website_sessions s 
        ON s.website_session_id = o.website_session_id 
    GROUP BY s.user_id
), 
query4 AS (
    SELECT 
        s.user_id, 
        COUNT(distinct(s.user_id)) AS purchased
    FROM order_items oi 
    JOIN orders o 
        ON o.order_id = oi.order_id 
    JOIN website_sessions s 
        ON s.website_session_id = o.website_session_id
    LEFT JOIN order_item_refunds re 
        ON re.order_id = o.order_id 
    WHERE re.order_item_refund_id IS NULL
    GROUP BY s.user_id
) 
SELECT 
    q1.device_type,
    SUM(q1.ws_ses) AS web_sessions,
    SUM(COALESCE(q2.page_interaction, 0)) AS page_interactions,
    SUM(COALESCE(q3.orders, 0)) AS total_orders,
    SUM(COALESCE(q4.purchased, 0)) AS total_purchased
FROM query1 q1
LEFT JOIN query2 q2 ON q1.user_id = q2.user_id
LEFT JOIN query3 q3 ON q1.user_id = q3.user_id
LEFT JOIN query4 q4 ON q1.user_id = q4.user_id
GROUP BY q1.device_type;

-------------------------------------------------------------------------
--3) Which marketing tool is better marketing or content marketing?

select COUNT(*) from website_sessions where utm_campaign='NULL' and utm_source in ('NULL','socialbook')


WITH query1 AS (
    SELECT 
        user_id, 
        device_type,is_content,utm_source,year_,month_,time_,
        COUNT(distinct(user_id)) AS ws_ses
    FROM website_sessions
    GROUP BY user_id, device_type,is_content,utm_source,year_,month_,time_
), 
query2 AS (
    SELECT 
        s.user_id, 
        COUNT(distinct(s.user_id)) AS page_interaction
    FROM website_pageviews v 
    JOIN website_sessions s 
        ON s.website_session_id = v.website_session_id 
    WHERE v.pageview_url IN ('/home','/products','/cart','/shipping','/billing')
    GROUP BY s.user_id
),
query3 AS (
    SELECT 
        s.user_id, 
        COUNT(distinct(s.user_id)) AS orders,
		Total_Revenue
    FROM orders o 
    JOIN website_sessions s 
        ON s.website_session_id = o.website_session_id 
    GROUP BY s.user_id,Total_Revenue
), 
query4 AS (
    SELECT 
        s.user_id, 
        COUNT(distinct(s.user_id)) AS purchased
    FROM order_items oi 
    JOIN orders o 
        ON o.order_id = oi.order_id 
    JOIN website_sessions s 
        ON s.website_session_id = o.website_session_id
    LEFT JOIN order_item_refunds re 
        ON re.order_id = o.order_id 
    WHERE re.order_item_refund_id IS NULL
    GROUP BY s.user_id
) 
SELECT 
	q1.user_id,
	q1.year_,
	q1.month_,
	q1.time_,
    q1.device_type,
	q1.utm_source,
	q1.is_content,
    q1.ws_ses AS web_sessions,
    q2.page_interaction AS page_interactions,
    q3.orders AS total_orders,
    q4.purchased AS total_purchased,
	q3.Total_Revenue AS Revenue
FROM query1 q1
LEFT JOIN query2 q2 ON q1.user_id = q2.user_id
LEFT JOIN query3 q3 ON q1.user_id = q3.user_id
LEFT JOIN query4 q4 ON q1.user_id = q4.user_id 
;


