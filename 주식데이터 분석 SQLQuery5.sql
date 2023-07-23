-- 52주 최저가, 최고가, 가격차이, 비율 검색
select
  symbol,
  CONVERT(decimal(18,2), MIN([close])) as w52_min,
  CONVERT(decimal(18,2), MAX([close])) as w52_max,
  CONVERT(decimal(18,2), MAX([close]) - MIN([close])) as w52_diff_price,
  CONVERT(decimal(18,2), (MAX([close]) - MIN([close])) / MIN([close]) * 100) as w52_diff_ratio
from stock
where date >= DATEADD(week, -52, '2021-01-01') AND date <= '2021-01-01'
group by symbol
order by w52_max desc


-- 기간 동안 종목별 등락 계산
select 
  a.symbol,
  a.[close] as a_close,
  b.[close] as b_close,
  b.[close] - a.[close] as close_diff,
 (b.[close] - a.[close]) /a.[close] * 100 as ratio_diff
 INTO #temp
from (
 select
   symbol,
   [close]
 from stock
 where date = '2021-02-17'
 ) AS a
 INNER JOIN (
 select
  symbol,
  [close]
from stock
where date = '2021-02-24'
) AS b ON a.symbol = b.symbol

select * from #temp

-- 10%  이상 상승한 종목만 조인해 데이터 저장
select
 ROW_NUMBER() OVER (PARTITION BY a.symbol ORDER BY date ASC) as num,
 a.symbol,
 b.date,
 b.[close]
 INTO #temp2
from #temp as a
  INNER JOIN stock as b on a.symbol = b.symbol
where a.ratio_diff >= 10
 AND b.date >= '2021-02-17'
 AND b.date <= '2021-02-24'

 select * from #temp2

 -- 3. 같은 symbol 기준으로 전일 데이터 비교
 select
   b.symbol,
   a.[date] as a_date,
   a.[close] as a_close,
   b.[date] as b_date,
   b.[close] as b_close,
   b.[close] - a.[close] as close_diff,
   (b.[close] - a.[close]) / a.[close]*100 as ratio_diff
   INTO #temp3
from #temp2 as a
 INNER JOIN #temp2 AS b ON a.symbol = b.symbol AND a.num = b.num -1
ORDER BY b.symbol, b.date

select * from #temp3

-- 4. 하락이 한번도 없는 데이터 추출
select
 symbol, 
 a_date,
 ROUND(a_close, 2) as a_close,
 b_date,
 ROUND(b_close, 2) as b_close,
 ROUND(close_diff, 2) as close_diff,
 ROUND(ratio_diff, 2) as ratio_diff
 INTO #temp4
from #temp3
where symbol NOT IN (select symbol from #temp3 where ratio_diff < 0 group by symbol)

select * from #temp4

-- 5. nasdaq_company 테이블과 앞의 임시 테이블을 조인해 최종 정보 표시
select
 a.symbol,
 d.company_name,
 d.industry,
 ROUND(a.a_close, 2) as a_close,
 ROUND(a.b_close, 2) as b_close,
 ROUND(a.close_diff, 2) as diff_price,
 ROUND(a.ratio_diff, 2) as diff_ratio
from #temp4 as a
INNER JOIN (select symbol from #temp2 group by symbol) as b on a.symbol = b.symbol
INNER JOIN (select symbol from #temp4 group by symbol) as c on a.symbol = c.symbol
INNER JOIN nasdaq_company as d on a.symbol = d.symbol
ORDER BY ratio_diff DESC

-- 임시 테이블 삭제
DROP TABLE #temp
DROP TABLE #temp2
DROP TABLE #temp3
DROP TABLE #temp4



