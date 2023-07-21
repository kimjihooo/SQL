-- 서브 퀴리 활용
-- where 절
select *
from stock
where symbol in (
 select symbol
 from nasdaq_company
 where company_name like '%Micro%')
and date >= '2021-04-01'
and date <= '2021-04-10'

-- from 절
select a.*
from stock as a
  inner join (
    select symbol
	from nasdaq_company
	where company_name like '%Micro%'
	) as b on a.symbol = b.symbol
where a.date >='2021-04-01'
and a.date < '2021-04-10'

-- select 절
select 
  a.symbol,
  (select company_name From nasdaq_company as b where b.symbol = a.symbol) as company_name,
  (select ipo_year From nasdaq_company as b where b.symbol = a.symbol) as ipo_year,
  a.date, a.[open], a.[high]
from stock as a
where a.symbol = 'MSFT' AND a.date >= '2021-10-01' AND a.date < '2021-11-01'
