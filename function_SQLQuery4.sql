-- ���� �� �������� �� ���� ���� ����
select date,
  LAG ([close]) OVER (ORDER BY [close] ASC) AS lag_price,
  [close],
  LEAD([close]) OVER (ORDER BY [close] ASC) AS lead_price
from stock
where symbol = 'MSFT'
  AND date >= '2021-01-01' AND date < '2021-01-20'

 
-- ���� ���� ���ϱ�
select symbol, sector, 
  ROUND(close_price, 0),
  CUME_DIST() OVER(ORDER BY ROUND(close_price, 0) DESC) AS CUME_DIST
from nasdaq_company

-- ��� ���� ���ϱ�
select 
symbol, sector,
ROUND(close_price, 0),
PERCENT_RANK() OVER(ORDER BY ROUND(close_price, 0) DESC) AS PERCENT_RANK
from nasdaq_company

-- ���ڿ�
select 
concat(symbol, N'�� ����� ', industry, N' �Դϴ�.')
from nasdaq_company where symbol = 'MSFT'


-- ISNULL
select concat(symbol, N'�� ����� ', ISNULL(industry, 'UKNOW'))
from nasdaq_company where symbol = 'DBA'

-- DATE 
select getdate()

-- 
select 
  count(*) as all_cnt,
  count(industry) as ipo_cnt
from nasdaq_company

-- CUBE : ���� ������ ���� �׷�ȭ ������ ��� ���տ� ���� �Ұ�
select
  sector, industry,
  sum([close_price]) as col_sum
from nasdaq_company 
group by cube(sector, industry)

-- ROLLUP : ���� ������ ���� ����ȭ ������ �κ���
select sector, industry,
  sum([close_price]) as col_sum
from nasdaq_company
group by rollup(sector, industry)