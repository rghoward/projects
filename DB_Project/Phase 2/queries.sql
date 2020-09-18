-- count of stores, manufacturers, products, and managers in data warehouse from 2nd paragraph of spec
-- Uses CTE https://www.postgresql.org/docs/9.1/queries-with.html
\echo '----------------------------------------------------------------------------------------------------'
\echo 'count of stores, manufacturers, products, and managers in data warehouse from 2nd paragraph of spec'
\echo '----------------------------------------------------------------------------------------------------'

with sc as ( select
	count(s.store_number) as store_count
from
	sedw.store s ),
mc as ( select
	count(m.id) as manufacturers
from
	sedw.manufacturer m ),
p as ( select
	count(p.pid) as products
from
	sedw.product p ),
manager as ( select
	count( case when manager.status = 'active'::employment_status then 1 end ) as active_managers, 
    count( case when manager.status = 'inactive'::employment_status then 1 end ) as inactive_managers
from
	sedw.manager ) select
	store_count,
	manufacturers,
	products,
	active_managers,
	inactive_managers
from
	sc,
	mc,
	p,
	manager;


-- Report 1
\echo '----------------------------------------------------------------------------------------------------'
\echo 'Report 1'
\echo '----------------------------------------------------------------------------------------------------'
select
    m.id,
	m.name,
	count( distinct(p.pid)) as total_products,
	round( avg(p.retail_price)::numeric, 2 ) as avg_retail_price,
	round( min(p.retail_price)::numeric, 2 ) as min_retail_price,
	round( max(p.retail_price)::numeric, 2 ) as max_retail_price
from
	sedw.manufacturer m
inner join sedw.product p on
	p.manufacturer_id = m.id
group by
	m.name,m.id
order by
	avg( p.retail_price ) desc
limit 100;


-- Report 1 Drill Down
-- set the m.name to the desired manufacturer

\echo '----------------------------------------------------------------------------------------------------'
\echo 'Report 1 Drill Down with manufacturer=garmin'
\echo '----------------------------------------------------------------------------------------------------'
select
	m.name,p.pid,p.name as product_name,
	round(p.retail_price::numeric, 2 ) as retail_price,
	string_agg(c."name",',')as category_name
from
	sedw.manufacturer m
inner join sedw.product p on
	p.manufacturer_id = m.id
	inner join sedw.belongs_to bt on bt.pid=p.pid
	inner join sedw.category c on c."name"=bt."name"
	where m."name"='garmin'
group by
	m.name,p.pid,p.name
order by
	 p.retail_price desc;

\echo '----------------------------------------------------------------------------------------------------'
\echo 'Report 2'
\echo '----------------------------------------------------------------------------------------------------'
-- Report 2
select
	c.name,
	count( distinct( bt.pid )) as products_in_category,
	count( distinct( m.id )) as unique_manufacturers,
	round( avg( retail_price )::decimal, 2 ) as avg_retail_price
from
	sedw.category c
inner join belongs_to bt on bt."name"=c."name"
inner join product p on p.pid=bt.pid
inner join manufacturer m on m.id = p.manufacturer_id
group by
	c.name
order by
	c.name asc;


\echo '----------------------------------------------------------------------------------------------------'
\echo 'Report 3'
\echo '----------------------------------------------------------------------------------------------------'
-- Report 3
Select
	*
from
	(
	Select
		bt.pid,
		p.name,
		p.retail_price,
		get_total.total_units_sold,
		get_discounted_units.units_sold_at_discount,
		get_total.total_units_sold - get_discounted_units.units_sold_at_discount as units_sold_at_retail_price,
		round(((get_total.total_units_sold-get_discounted_units.units_sold_at_discount) * p.retail_price + get_discounted_units.discounted_revenue)::numeric,
		2) as actual_revenue,
		round((get_discounted_units.units_sold_at_discount * 0.75 + get_total.total_units_sold-get_discounted_units.units_sold_at_discount) * p.retail_price::numeric,
		2) as predicted_revenue,
		round(((get_total.total_units_sold-get_discounted_units.units_sold_at_discount) * p.retail_price + get_discounted_units.discounted_revenue)::numeric,
		2) - round((get_discounted_units.units_sold_at_discount * 0.75 + get_total.total_units_sold-get_discounted_units.units_sold_at_discount) * p.retail_price::numeric,
		2) as difference
	from
		category c
	inner join belongs_to bt on
		c.name = bt.name
	inner join product p on
		bt.pid = p.pid
	inner join (
		select
			tracks_sold.pid,
			sum(quantity) as units_sold_at_discount,
			sum(tracks_sold.quantity * sale.sale_price) as discounted_revenue
		from
			tracks_sold
		inner join sale on
			tracks_sold.pid = sale.pid
		inner join sale_sale_date on
			tracks_sold.date = sale_sale_date.sale_date
			and sale.sale_id = sale_sale_date.sale_id
		group by
			tracks_sold.pid ) as get_discounted_units on
		get_discounted_units.pid = bt.pid
	inner join (
		select
			pid,
			sum(quantity) as total_units_sold
		from
			tracks_sold
		group by
			pid ) as get_total on
		bt.pid = get_total.pid
	where
		c.name = 'gps') report
where
	abs(report.difference) > 5000
order by
	report.difference desc;


\echo '----------------------------------------------------------------------------------------------------'
\echo 'Report 4 State select '
\echo  'Below has New York hard coded; this will be taken from drop-down'
\echo '----------------------------------------------------------------------------------------------------'
-- Report 4 State select
-- Below has New York hard coded; this will be taken from drop-down
select 
store_number,
street_number ,
street_name ,
city_name,
year,
sum(revenue)as total_revenue
from 
(  -- First we need to get product sales with discount applied, then we can aggregate
   select
	s.store_number,
	s.street_number ,
	s.street_name ,
	c.city_name,
	extract ( year from ts."date" )::integer as year,
	-- ts.quantity*p.retail_price,
	p.pid,
	p."name",
	sale.pid,
	ts."date",
	ts.quantity,
	ROUND((COALESCE(sale.sale_price, p.retail_price)*ts.quantity)::numeric,2) as revenue
	-- s.street_number || ' ' || s.street_name || ' ' || c.city_name || ',' || c.state_name as address
from
	sedw."store" s
inner join sedw.city c on c.id = s.city_id and c.state_name = 'New York'
inner join sedw.tracks_sold ts on ts.store_number = s.store_number
inner join sedw.product p on p.pid = ts.pid
left join sedw.sale on sale.pid=p.pid
left join sedw.sale_sale_date sd on sd.sale_id=sale.sale_id
)apply_discount
group by
	store_number,
	street_number ,
	street_name ,
	city_name,
	year
	order by year asc, total_revenue desc;


-- Report 5 Groundhog Day
\echo '----------------------------------------------------------------------------------------------------'
\echo 'Report 5 Groundhog Day'
\echo '----------------------------------------------------------------------------------------------------'
select * from (
                select extract(YEAR from ssd.sale_date)                       as year,
                       count(sale.sale_id)                                    AS sales,
                       to_char(count(sale.sale_id)::FLOAT / 365, '99999.000') AS daily_sales
                from sale
                       join sale_sale_date ssd on sale.sale_id = ssd.sale_id
                       join product p on sale.pid = p.pid
                       join belongs_to bt on p.pid = bt.pid
                where bt.name = 'Air Conditioner'
                group by extract(YEAR from ssd.sale_date)
                order by extract(YEAR from ssd.sale_date) ASC
              ) as tab1

JOIN (
  select extract(YEAR from ssd.sale_date) as year,
         count(sale.sale_id)              AS GroundhogDay_Sales
  from sale
         join sale_sale_date ssd on sale.sale_id = ssd.sale_id
         join product p on sale.pid = p.pid
         join belongs_to bt on p.pid = bt.pid
  where bt.name = 'Air Conditioner'
    and extract(DOY from ssd.sale_date) = 33
  group by extract(YEAR from ssd.sale_date)
  order by extract(YEAR from ssd.sale_date) ASC
) as tab2
on tab1.year = tab2.year;


-- Report 6 List available months.
\echo '----------------------------------------------------------------------------------------------------'
\echo 'Report 6 List available months.'
\echo '----------------------------------------------------------------------------------------------------'
select
    extract( year from ts.date ) as the_year,
    extract( month from ts.date ) as the_month
from
    sedw.tracks_sold ts
group by
    the_year,
    the_month;

-- Report 6 for month and year rank=1 category; includes ties
\echo '----------------------------------------------------------------------------------------------------'
\echo 'Report 6 for month and year rank=1 category; includes ties'
\echo '----------------------------------------------------------------------------------------------------'
select final_output.* from 
(select
	state_name,
	category,
	the_year,
	the_month,
	units_sold,
	total_revenue,
	rank() over ( partition by state_name, category order by units_sold desc )
from (
	select
state_name,
category,
the_year,
the_month,
sum(quantity) as units_sold,
sum(revenue)as total_revenue
from
(  -- First we need to get product sales with discount applied, then we can aggregate
   select
    state.state_name,
    extract( year from ts.date )::integer as the_year,
    extract( month from ts.date )::integer as the_month,
    ROUND((COALESCE(sale.sale_price, p.retail_price)*ts.quantity)::numeric,2) as revenue,
    ts.quantity,
    b."name" as category
from sedw."store" s
inner join sedw.city c on c.id = s.city_id -- and c.state_name = 'New York'
inner join sedw.tracks_sold ts on ts.store_number = s.store_number
inner join sedw.product p on p.pid = ts.pid
left join sedw.sale on sale.pid=p.pid 
left join sedw.sale_sale_date sd on sd.sale_id=sale.sale_id
inner join sedw.state on state.state_name=c.state_name
inner join sedw.belongs_to b on b.pid=p.pid
where 1=1
and extract( year from ts.date )::integer='2018'
and  extract( month from ts.date )::integer='01'
)apply_discount
group by
    state_name,
    category,
    -- store_number,
    -- street_number ,
    -- street_name ,
    -- city_name,
    the_year,
    the_month)category_by_state  order by category)final_output where rank=1;


-- Report 6 Drill-Down
\echo '----------------------------------------------------------------------------------------------------'
\echo 'Report 6 Drill-Down Hard coded in where clause'
\echo '----------------------------------------------------------------------------------------------------'
select 
topstore.store_number,
topstore.address,
topstore.city_name,
m.first_name,
m.last_name,
m.email_address
from
(  
   select
   s.store_number,
   s.street_number || ' ' || s.street_name || ' ' || c.city_name || ',' || c.state_name as address,
    state.state_name,
    c.city_name,
    extract( year from ts.date )::integer as the_year,
    extract( month from ts.date )::integer as the_month,
    b."name" as category
from sedw."store" s
inner join sedw.city c on c.id = s.city_id -- and c.state_name = 'New York'
inner join sedw.tracks_sold ts on ts.store_number = s.store_number
inner join sedw.product p on p.pid = ts.pid
left join sedw.sale on sale.pid=p.pid 
left join sedw.sale_sale_date sd on sd.sale_id=sale.sale_id
inner join sedw.state on state.state_name=c.state_name
inner join sedw.belongs_to b on b.pid=p.pid
where 1=1
and extract( year from ts.date )::integer='2018'
and  extract( month from ts.date )::integer='01'
group by s.store_number, address, city_name,state.state_name,the_year,the_month,b."name"
)topstore
inner join sedw.managed_by mb on mb.store_number=topstore.store_number
inner join sedw.manager m on m.email_address=mb.email_address
    where 1=1
    and topstore.category='electronics' and topstore.state_name='New York' and the_year='2018' and the_month='1'
	order by topstore.store_number asc
   ;

-- Report 7 with city_size as columns
\echo '----------------------------------------------------------------------------------------------------'
\echo 'Report 7 CitySize as columns'
\echo '----------------------------------------------------------------------------------------------------'
 select * from crosstab('
select 
the_year,
city_size,
ROUND(avg(sum_revenue)::numeric,2)as avg_revenue
from (
      select
        s.city_id,
        s.store_number,
        year::integer the_year,
        case  
        when  population < 3.7*10^6 then  ''a''                           /*Small*/
        when  population >= 3.7*10^6 and population < 6.7*10^6 then ''b'' /*Medium*/
        when  population >= 6.7*10^6 and population < 9*10^6 then ''c''	  /*Large*/
        when  population >=  9*10^6 then ''d'' end as city_size, 		  /*Extra Large*/
        sum(revenue) as sum_revenue
    from
        city c
    inner join store s on
        c.id = s.city_id
    inner join store_revenue sr on
        s.store_number = sr.store_number
    group by the_year, city_size,s.store_number,city_id
       order by the_year,city_size)store_revenue 
       group by the_year, city_size order by the_year, city_size'
) as ct(the_year integer,Small_City numeric,Medium_City numeric, Large_City numeric,Extra_Large_City numeric  );


-- Report 7
select
	size,
	round(avg(revenue)::numeric,2) as average_revenue,
	year
from
	(
values ('small',
0,
3700000),
('medium',
3700000,
6700000),
('large',
6700000,
9000000),
('extra large',
9000000,
10000000000)) as t (size,
	min,
	max)
inner join (
	select
		city_id,
		s.store_number,
		year,
		population,
		sum(revenue)as revenue
	from
		city c
	inner join store s on
		c.id = s.city_id
	inner join store_revenue sr on
		s.store_number = sr.store_number
	group by
		city_id,
		s.store_number,
		sr.year,
		population ) as t2 on
	t2.population >= t.min
	and t2.population < t.max
group by
	size,
	year
order by
	size desc, --the reason size is desc is because alphabetically, this would make the categories ascending
	year asc;

\echo '----------------------------------------------------------------------------------------------------'
\echo 'Maintain Manager: Add Manager' with test manager Jane Doe
\echo '----------------------------------------------------------------------------------------------------'
insert into sedw.manager
	(email_address, 
        first_name, 
        last_name, 
        status)
values('jane.doe@testingemail.com', 
       'Jane',
       'Doe',
       'active'::employment_status);

\echo '----------------------------------------------------------------------------------------------------'
\echo 'Maintain Manager: Assign a Manager to a Store' with test manager Jane Doe
\echo '----------------------------------------------------------------------------------------------------'
insert into sedw.managed_by
	(store_number,
	email_address)
values(4, 'jane.doe@testingemail.com');

\echo '----------------------------------------------------------------------------------------------------'
\echo 'Maintain Manager: Unassign a Manager from a Store' with test manager Jane Doe
\echo '----------------------------------------------------------------------------------------------------'

delete from sedw.managed_by
where store_number=4 AND email_address='jane.doe@testingemail.com';

\echo '----------------------------------------------------------------------------------------------------'
\echo 'Maintain Manager: Delete a Manager' with test manager Jane Doe
\echo '----------------------------------------------------------------------------------------------------'

delete from sedw.manager
where email_address='jane.doe@testingemail.com';  
