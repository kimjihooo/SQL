-- 현재 행 기준으로 앞 뒤의 행을 참조
select date,
  LAG ([close]) OVER (ORDER BY [close] ASC) AS lag_price,
  [close],
  LEAD([close]) OVER (ORDER BY [close] ASC) AS lead_price
from stock
where symbol = 'MSFT'
  AND date >= '2021-01-01' AND date < '2021-01-20'

 
-- 누적 분포 구하기
select symbol, sector, 
  ROUND(close_price, 0),
  CUME_DIST() OVER(ORDER BY ROUND(close_price, 0) DESC) AS CUME_DIST
from nasdaq_company

-- 상대 순위 구하기
select 
symbol, sector,
ROUND(close_price, 0),
PERCENT_RANK() OVER(ORDER BY ROUND(close_price, 0) DESC) AS PERCENT_RANK
from nasdaq_company

-- 문자열
select 
concat(symbol, N'의 산업은 ', industry, N' 입니다.')
from nasdaq_company where symbol = 'MSFT'


-- ISNULL
select concat(symbol, N'의 산업은 ', ISNULL(industry, 'UKNOW'))
from nasdaq_company where symbol = 'DBA'

-- DATE 
select getdate()

-- 
select 
  count(*) as all_cnt,
  count(industry) as ipo_cnt
from nasdaq_company

-- CUBE : 집계 쿼리에 대한 그룹화 수준의 모든 조합에 대한 소계
select
  sector, industry,
  sum([close_price]) as col_sum
from nasdaq_company 
group by cube(sector, industry)

-- ROLLUP : 집계 쿼리에 대한 계층화 구조의 부분합
select sector, industry,
  sum([close_price]) as col_sum
from nasdaq_company
group by rollup(sector, industry)