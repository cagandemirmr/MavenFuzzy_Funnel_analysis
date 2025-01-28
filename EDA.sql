--First I discover data and started this process by website pageview

select * from website_pageviews
--1.188.124 Raws and 4 columns

select MIN(created_at) from website_pageviews
--Oldest Time 2012-03-19 08:04:16.0000000

select MAX(created_at) from website_pageviews
--Newest time 2015-03-19 07:59:32.0000000

select COUNT(distinct website_session_id) from website_pageviews
--Distinct website session id is 472871

select COUNT(distinct(pageview_url)) from website_pageviews
--Distinct pageview URL is 16

select distinct(pageview_url) from website_pageviews order by 1
/* /billing
/billing-2
/cart
/home
/lander-1
/lander-2
/lander-3
/lander-4
/lander-5
/products
/shipping
 thank-you-for-your-order
/the-birthday-sugar-panda
/the-forever-love-bear
/the-hudson-river-mini-bear
/the-original-mr-fuzzy */;

select * from website_pageviews where  created_at is not null and website_session_id is not null and pageview_url is not null
--1.188.124 Raws are not null that means there is no null value

select count(distinct(created_at)) from website_pageviews
--1.171.962

select COUNT(distinct(website_pageview_id)) from website_pageviews
--1.188.124

select COUNT(distinct(website_session_id)) from website_pageviews
--472.871

--Pageview_id vs session_id
--In every ection pageview id of visitor change but in session_id, every visitor have an id as long as their session end.
-------------------------------------------------------------------------------------------------------------------------------
--WEBSITE SESSIONS

select * from website_sessions
--9 columns 472.871 Raws

select MIN(created_at) as min_,MAX(distinct(created_at)) as max_,COUNT(distinct(user_id))as user_count,COUNT(distinct(is_repeat_session)) as Repeat_count, COUNT(distinct(utm_source)) as UTM_count,
count(distinct(utm_campaign)) as UTM_campain,COUNT(distinct(utm_content)) as utm_content,COUNT(distinct(device_type)) as Device_type from website_sessions

--2012-03-19 08:04:16.0000000 / 2015-03-19 07:59:08.0000000	/394318 /	2 /	4 /	5 /	7	/2

select distinct(is_repeat_session) from website_sessions
/* 0
   1 */

select distinct(utm_source) from website_sessions
/* NULL
bsearch
socialbook
gsearch */


select distinct(utm_campaign) from website_sessions
/* desktop_targeted
brand
NULL
pilot
nonbrand */



select * from website_sessions where utm_campaign='NULL' and utm_source in ('NULL','socialbook')
-- 83.328 people come from organically without any ad.

-----------------------------------------------------------------------------------------------
--Create columns to define ads from content

ALTER TABLE website_sessions
ADD is_content nvarchar(50); --Create column to add content based campaigns

UPDATE website_sessions
set is_content = case when utm_campaign='NULL' and utm_source in ('NULL','socialbook') then 'content' else 'Ad' end  

select  case when utm_campaign='NULL' and utm_source in ('NULL','socialbook') then 'content' else 'Ad' end  from  website_sessions

select * from website_sessions 

--pilot means sample of people that campaigned showed to  test of campaign
-- nonbrand campaigns based on SEO and Hastags 

select distinct(utm_content) from website_sessions
/*social_ad_2
NULL
g_ad_1
b_ad_1
social_ad_1
g_ad_2
b_ad_2 */

---------------------------------------------------
--UPDATE COLUMN

select * from website_sessions where utm_content  in ('g_ad_1','g_ad_2')

update website_sessions
set utm_source = case when utm_content in ('g_ad_1','g_ad_2') then 'g_ad' 
					  when utm_content in ('b_ad_1','b_ad_2') then 'b_ad' 
					  when utm_content='social_ad_1' then 'social'
					  else 'organic' end

--------------------------------------------------------
--CREATING TIME VARIABLES

select YEAR(created_at) from website_sessions

alter table website_sessions
add year_ INT;

update website_sessions
set year_ = YEAR(created_at)

alter table website_sessions
add month_ INT;

update website_sessions
set month_ = MONTH(created_at)

select distinct(datepart(hour,created_at)) from website_sessions order by 1

alter table website_sessions
add time_ int;

update website_sessions
set time_ = datepart(hour,created_at);


--------------------------------------------------------




select distinct(device_type) from website_sessions
/* desktop
   mobile */


select device_type,COUNT(distinct(user_id)) count_ from website_sessions group by device_type
/* desktop	288580
   mobile	133839 */ --Most of the customers came from desktop



select utm_source,COUNT(distinct(user_id)) count_ from website_sessions group by utm_source

/* NULL	66144
bsearch	61965
socialbook	10685
gsearch	299700 */ --Most of customer came from gsearch


select distinct(utm_content),COUNT(distinct(user_id)) count_ from website_sessions group by utm_content order by 2
/* social_ad_1	5095
   social_ad_2	5590
   b_ad_2	    7717
   g_ad_2	    30121
   b_ad_1	    54909
   NULL	        66144
   g_ad_1	    282706 */ --And came from g_ad_1

select distinct(utm_campaign),COUNT(distinct(user_id)) from website_sessions group by utm_campaign order by 2
/* pilot	        5095
  desktop_targeted	5590
  brand	            36439
  NULL	            66144
  nonbrand	        337615 */ --nonbrand campaigns and brand companies are most popular ones.


  select COUNT(*) from website_sessions where website_session_id is not null  and created_at is not null and user_id is not null and is_repeat_session is not null and utm_source is not null and
  utm_campaign is not null and utm_content is not null and device_type is not null and http_referer is not null

  

  --472871 raws are not null so there is no missing value

  -----------------------------------------------------------
  --ORDERS

  select * from orders
  --8 columns 32.313 Raws

  Alter table orders
  add Total_Revenue int;

  update orders
  set Total_Revenue = price_usd * items_purchased;


  select MIN(created_at) min_date,MAX(created_at) max_date,COUNT(distinct(website_session_id)) website_ses,COUNT(distinct(user_id)) user_count,COUNT(distinct(primary_product_id)) product_count,COUNT(distinct(items_purchased)) purchased_product_count,COUNT(distinct(price_usd)) price_usd,MIN(cogs_usd) usd_min,MAX(cogs_usd) usd_max from orders
  -- 2012-03-19 10:42:46.0000000	2015-03-19 05:38:31.0000000	32313	31696	4	2	10	09:49:00.0000000	22:49:00.0000000

  select * from orders where order_id is not null and created_at is not null and website_session_id is not null and user_id is not null and primary_product_id is not null and items_purchased is not null and price_usd is not null  and cogs_usd is not null

  -- 24.601 Rows are not null
  -- 32.313 Rows are null

  --7.712 Rows are null
 
 select * from orders where  created_at is  null and website_session_id is  null and
 user_id is  null and primary_product_id is  null and 
 items_purchased is  null and price_usd is  null  and cogs_usd is  null
 --There is no Row that multiple columns are null.

 select * from orders where  created_at is  null and website_session_id is  null 
 or user_id is  null or primary_product_id is  null 
 or items_purchased is  null or price_usd is  null  or cogs_usd is  null

 --Most of the missing values are from cogs_usd thats why i ignore them

 ---------------------------------------------------
 --ORDER ITEMS

 select * from order_items
 --Maybe i can fill cogs_usd with right or left join
 --7 columns and 40.025 Rows

 select MIN(created_at) min_,MAX(created_at) max_,MIN(cogs_usd) min_cogs,MAX(cogs_usd) max_cogs from order_items
 --2012-03-19 10:42:46.0000000	2015-03-19 05:38:31.0000000	09:49:00.0000000	22:49:00.0000000

 select * from order_items where created_at is  null or order_id is  null or product_id is  null or is_primary_item is  null or price_usd is  null or price_usd is  null or cogs_usd is  null
 -- 40.025 Rows are not null so there is no worry

 select distinct(is_primary_item) from order_items
 -- It is gives info whether it is primary product or not

 ----------------------------------------------------
 --ITEMS

 select * from order_item_refunds
 -- 1731 columns 

 select * from order_item_refunds where  created_at is  null or order_item_id is  null or order_id is null or refund_amount_usd is  null
 -- There is no null values

 -----------------------------------------------------
 --PRODUCTS

 select * from products
 -- 3 columns 4 Rows


--------------------------------------------------------
--ORDER ITEM REFUNDS

select * from order_item_refunds
-- 5 columns 1.731 Raws




