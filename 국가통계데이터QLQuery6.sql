select * from census_2022_data

-- 2015- 2020 ������ ���
select top 10 * from census_2015_2020

-- ��ü �α��� ������ ����
select 
 a.[����] as a_year,
 a.[���α� (��)] as a_popluation,
 b.[����] as b_year,
 b.[���α� (��)] as b_popluation,
 b.[���α� (��)] - a.[���α� (��)] as diff_poplulation,
 CONVERT(Decimal(18,2), (b.[���α� (��)] - a.[���α� (��)]) / a.[���α� (��)] * 100) as diff_ratio
from census_2015_2020 as a
 left outer join census_2015_2020 as b on a.[C����������(���鵿)] = b.[C����������(���鵿)] AND a.[����] = b.[����] -1
where a.[C����������(���鵿)] = '00'

-- ���� ���� �ڵ�� ��/�� �α��� ������ ����, ������ �˻�
select 
 a.[C����������(���鵿)] as c_city,
 a.[����������(���鵿)] as city,
 a.[����] as a_year,
 a.[���α� (��)] as a_popluation,
 b.[����] as b_year,
 b.[���α� (��)] as b_popluation,
 b.[���α� (��)] - a.[���α� (��)] as diff_popluation,
 convert(decimal(18,2), (b.[���α� (��)] - a.[���α� (��)]) / a.[���α� (��)] * 100) as diff_ratio
from census_2015_2020 as a
left outer join census_2015_2020 as b on a.[C����������(���鵿)] = b.[C����������(���鵿)] AND a.[����] = b.[����] -1
where a.[C����������(���鵿)] like '[^0]_'
order by a.[C����������(���鵿)], a.[����]


-- Ư���� ������ ��� �ŸŰ� ���� ���� �м�
with cte_house as (
  select
  ROW_NUMBER() over (order by [�ŷ���] ASC) as num,
  [����������],
  [������],
  [���ñԸ�],
  [�׸�],
  [�ŷ���],
  [�ŷ�����]
  from house_transaction
  where [����������] = N'����Ʈ' AND [������] = N'����' AND [���ñԸ�] = N'�Ը�3')
select
  a.[����������],
  a.[���ñԸ�],
  c.code_value,
  a.[�ŷ���] as a_date, convert(decimal(18,2), a.[�ŷ�����]) as a_transaction,
  b.[�ŷ���] as b_date, convert(decimal(18,2), b.[�ŷ�����]) as b_transaction,
  CONVERT(decimal(18,2), a.[�ŷ�����] - b.[�ŷ�����]) as diff_transaction
from cte_house as a
  cross join (select [�ŷ���],[�ŷ�����] from cte_house where [�ŷ���] = '2012-01') as b
  left outer join house_scale_code as c on a.[����������] = c.[����������] AND a.[���ñԸ�] = c.[���ñԸ�]
order by a.num asc


