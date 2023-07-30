select * from census_2022_data

-- 2015- 2020 데이터 사용
select top 10 * from census_2015_2020

-- 전체 인구의 연도별 증감
select 
 a.[시점] as a_year,
 a.[총인구 (명)] as a_popluation,
 b.[시점] as b_year,
 b.[총인구 (명)] as b_popluation,
 b.[총인구 (명)] - a.[총인구 (명)] as diff_poplulation,
 CONVERT(Decimal(18,2), (b.[총인구 (명)] - a.[총인구 (명)]) / a.[총인구 (명)] * 100) as diff_ratio
from census_2015_2020 as a
 left outer join census_2015_2020 as b on a.[C행정구역별(읍면동)] = b.[C행정구역별(읍면동)] AND a.[시점] = b.[시점] -1
where a.[C행정구역별(읍면동)] = '00'

-- 행정 구역 코드로 시/도 인구의 연도별 증감, 증감률 검색
select 
 a.[C행정구역별(읍면동)] as c_city,
 a.[행정구역별(읍면동)] as city,
 a.[시점] as a_year,
 a.[총인구 (명)] as a_popluation,
 b.[시점] as b_year,
 b.[총인구 (명)] as b_popluation,
 b.[총인구 (명)] - a.[총인구 (명)] as diff_popluation,
 convert(decimal(18,2), (b.[총인구 (명)] - a.[총인구 (명)]) / a.[총인구 (명)] * 100) as diff_ratio
from census_2015_2020 as a
left outer join census_2015_2020 as b on a.[C행정구역별(읍면동)] = b.[C행정구역별(읍면동)] AND a.[시점] = b.[시점] -1
where a.[C행정구역별(읍면동)] like '[^0]_'
order by a.[C행정구역별(읍면동)], a.[시점]


-- 특정일 기준일 대비 매매가 지수 증감 분석
with cte_house as (
  select
  ROW_NUMBER() over (order by [거래월] ASC) as num,
  [주택유형별],
  [지역별],
  [주택규모별],
  [항목],
  [거래월],
  [거래지수]
  from house_transaction
  where [주택유형별] = N'아파트' AND [지역별] = N'전국' AND [주택규모별] = N'규모3')
select
  a.[주택유형별],
  a.[주택규모별],
  c.code_value,
  a.[거래월] as a_date, convert(decimal(18,2), a.[거래지수]) as a_transaction,
  b.[거래월] as b_date, convert(decimal(18,2), b.[거래지수]) as b_transaction,
  CONVERT(decimal(18,2), a.[거래지수] - b.[거래지수]) as diff_transaction
from cte_house as a
  cross join (select [거래월],[거래지수] from cte_house where [거래월] = '2012-01') as b
  left outer join house_scale_code as c on a.[주택유형별] = c.[주택유형별] AND a.[주택규모별] = c.[주택규모별]
order by a.num asc


