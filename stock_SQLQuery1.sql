select symbol, company_name
from nasdaq_company
where symbol = 'AAPL'
 or symbol= 'MSFT'
 or symbol = 'TSLA'

select symbol, company_name
from nasdaq_company
where symbol in ('AAPL', 'MSFT', 'TSLA')

-- A�� ���� ��� ������
select * from nasdaq_company where symbol like '%A%'
-- A�� �����ϴ� �α��� ������
select * from nasdaq_company where symbol like 'A_'
-- AA�� �����ϰ� c,p �� �ϳ��� ���� �ڿ��� ������� ������
select * from nasdaq_company where symbol like 'AA[c,p]%'
-- AA�� �����ϰ� L�� �������� �ʴ� ������
select * from nasdaq_company where symbol like 'AA[^L]%'

-- %�� ���Ե� ���� ã��
with CTE (col_1) as (
select 'A%BC' union all
select 'A_BC' union all
select 'ABC')

-- select * from CTE

select * from CTE where col_1 like '%#%%' escape '#'

-- �����ϱ�
select * from nasdaq_company
 order by ipo_year desc, symbol asc

 -- 'E'�� ���ԵǴ� industry�� �ش��ϴ� �� ���� ī��Ʈ (100�� �̻��� industry)
select industry,
       count(*) as cnt
from nasdaq_company
where industry Like '%E%'
group by industry
having count(*) >= 100
order by count(*) desc