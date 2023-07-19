select symbol, company_name
from nasdaq_company
where symbol = 'AAPL'
 or symbol= 'MSFT'
 or symbol = 'TSLA'

select symbol, company_name
from nasdaq_company
where symbol in ('AAPL', 'MSFT', 'TSLA')

-- A가 들어가는 모든 데이터
select * from nasdaq_company where symbol like '%A%'
-- A로 시작하는 두글자 데이터
select * from nasdaq_company where symbol like 'A_'
-- AA로 시작하고 c,p 중 하나가 들어가고 뒤에는 상관없는 데이터
select * from nasdaq_company where symbol like 'AA[c,p]%'
-- AA로 시작하고 L를 포함하지 않는 데이터
select * from nasdaq_company where symbol like 'AA[^L]%'

-- %가 포함된 문자 찾기
with CTE (col_1) as (
select 'A%BC' union all
select 'A_BC' union all
select 'ABC')

-- select * from CTE

select * from CTE where col_1 like '%#%%' escape '#'

-- 정렬하기
select * from nasdaq_company
 order by ipo_year desc, symbol asc

 -- 'E'가 포함되는 industry에 해당하는 행 개수 카운트 (100개 이상의 industry)
select industry,
       count(*) as cnt
from nasdaq_company
where industry Like '%E%'
group by industry
having count(*) >= 100
order by count(*) desc