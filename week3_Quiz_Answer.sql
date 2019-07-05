
—————————————
-Q2
—————————————
-- Right join

—————————————
-Q3:
—————————————
--On what day was Dillard’s income based on total sum of purchases the greatest?

SELECT saledate, SUM(quantity*sprice) as income
FROM trnsact
GROUP BY saledate
ORDER BY income DESC;
-----
SELECT saledate, SUM(amt)
FROM trnsact
WHERE stype = 'P'
GROUP BY saledate
ORDER BY SUM(amt) DESC;
-----
SELECT TOP 1 saledate, SUM(trnsact.amt) AS total_purchases
FROM trnsact
GROUP BY trnsact.saledate
ORDER BY total_purchases DESC;
-- 04/12/18

—————————————
-Q4:
—————————————
--What is the deptdesc of the departments that have the 
--top 3 greatest numbers of skus from the skuinfo table 
--associated with them?

SELECT d.DEPT, COUNT(s.sku) AS num, d.deptdesc
FROM deptinfo d INNER JOIN skuinfo s
ON d.dept = s.dept
GROUP BY d.dept, d.deptdesc
ORDER BY num DESC;
-----
SELECT TOP 3 d.deptdesc, COUNT(s.sku)
FROM skuinfo s LEFT JOIN deptinfo d
ON s.dept = d.dept
GROUP BY d.deptdesc
ORDER BY COUNT(s.sku) DESC;
-----
SELECT deptinfo.dept, deptinfo.deptdesc,  nr_different_skus
FROM 
	(SELECT TOP 3 deptinfo.dept, COUNT(UNIQUE skuinfo.sku) as nr_different_skus
	FROM skuinfo
	JOIN deptinfo
	ON skuinfo.dept = deptinfo.dept
	GROUP BY deptinfo.dept
	ORDER BY nr_different_skus DESC) AS T
JOIN deptinfo
ON T.dept = deptinfo.dept;
-- INVEST, POLOMEN, BRIOSO

—————————————
-Q5:
—————————————
--Which table contains the most distinct sku numbers?

SELECT DISTINCT COUNT(sku)
FROM ...;
-----
SELECT 'skstinfo' AS table_name , COUNT(UNIQUE sku) AS num_sku
FROM skstinfo
UNION
SELECT 'skuinfo' AS table_name , COUNT(UNIQUE sku) AS num_sku
FROM skuinfo
UNION  
SELECT 'transact' AS table_name , COUNT(UNIQUE sku) AS num_sku
FROM trnsact;
-- skuinfo

—————————————
-Q6:
—————————————
--How many skus are in the skstinfo table, but NOT in the skuinfo table?

SELECT COUNT(sk.sku)
FROM skuinfo s INNER JOIN skstinfo sk 
ON sk.sku=s.sku;
39230146

SELECT COUNT(sku)
FROM skstinfo;
40034112
-----
SELECT skstinfo.sku
FROM skstinfo LEFT JOIN skuinfo
ON skstinfo.sku = skuinfo.sku
WHERE skuinfo.sku IS NULL
GROUP BY skstinfo.sku; 
-----
SELECT COUNT(*)
FROM skstinfo
LEFT OUTER JOIN skuinfo
ON  skstinfo.sku = skuinfo.sku
WHERE skuinfo.sku IS NULL;
-- 0

—————————————
-Q7:
—————————————
--What is the average amount of profit Dillard’s made per day?

SELECT SUM(t.amt - s.cost)/COUNT(DISTINCT t.saledate)
FROM trnsact t LEFT JOIN skstinfo s
ON t.sku=s.sku AND t.store=s.store
WHERE stype = 'P';
-----
SELECT AVG(T.profit) (DECIMAL (10,5))
FROM
	(SELECT saledate, SUM((trnsact.sprice - skstinfo.cost)*trnsact.quantity) as profit
	FROM skstinfo
	JOIN trnsact
	ON skstinfo.sku = trnsact.sku AND skstinfo.store = trnsact.store
	WHERE trnsact.stype = 'P' AND trnsact.sprice <> 0
	GROUP BY saledate) AS T;
-- 1.53M

—————————————
-Q8:
—————————————
--The store_msa table provides population statistics about the 
--geographic location around a store. Using one query to retrieve 
--your answer, how many MSAs are there within the state of North 
--Carolina (abbreviated “NC”), and within these MSAs, what is the 
--lowest population level (msa_pop) and highest income level (msa_income)?

SELECT COUNT(msa), MIN(msa_pop),MAX(msa_income), state
FROM store_msa
GROUP BY state
WHERE state = 'NC';
-- 16 339511 36151
-- 16 MSAs, lowest population of 339,511, highest income level of $36,151

—————————————
-Q9:
—————————————
--What department (with department description), brand, style, and color 
--brought in the greatest total amount of sales?

SELECT s.dept, d.deptdesc, s.brand, s.style, s.color, SUM(t.amt) AS sales
FROM skuinfo s LEFT JOIN deptinfo d 
ON d.dept=s.dept
LEFT JOIN trnsact t
ON s.sku=t.sku
GROUP BY s.dept,d.deptdesc, s.brand, s.style, s.color
ORDER BY sales DESC;
-----
-- It can be chained with a JOIN deptinfo in order to pick the
-- description
SELECT deptinfo.dept, SUM(trnsact.amt) as total_sales, skuinfo.color, skuinfo.style, skuinfo.brand
FROM deptinfo
JOIN skuinfo
ON deptinfo.dept = skuinfo.dept
JOIN trnsact
ON skuinfo.sku = trnsact.sku
GROUP BY deptinfo.dept, skuinfo.color, skuinfo.style, skuinfo.brand
ORDER BY total_sales DESC;
-- 800 6438658.07 DDML 6142 CLINIQUE 

—————————————
-Q10:
—————————————
--How many stores have more than 180,000 distinct skus associated with 
--them in the skstinfo table?

SELECT store, COUNT(DISTINCT sku)
FROM skstinfo
GROUP BY store
HAVING COUNT(DISTINCT sku) > 180000;
-----
SELECT COUNT(*)
FROM 
	(SELECT strinfo.store
	FROM skstinfo
	JOIN strinfo
	ON strinfo.store = skstinfo.store
	GROUP BY strinfo.store
	HAVING COUNT(DISTINCT skstinfo.sku) > 180000) AS T;
-- 12

—————————————
-Q11
—————————————
--Look at the data from all the distinct skus in the “cop” 
--department with a “federal” brand and a “rinse wash” color. 
--You'll see that these skus have the same values in some of 
--the columns, meaning that they have some features in common.
*
--In which columns do these skus have different values from one 
--another, meaning that their features differ in the categories 
--represented by the columns? Choose all that apply. Note that
--you will need more than a single correct selection to answer 
--the question correctly.

SELECT DISTINCT *
FROM skuinfo LEFT JOIN deptinfo 
ON skuinfo.dept=deptinfo.dept
WHERE deptinfo.deptdesc='cop' 
      AND skuinfo.brand='federal' 
      AND skuinfo.color='rinse wash' ;
-----
SELECT *
FROM skuinfo
JOIN deptinfo
ON skuinfo.dept = deptinfo.dept
WHERE deptinfo.deptdesc = 'cop' 
     AND skuinfo.brand = 'federal' 
     AND skuinfo.color = 'rinse wash'  ;
-- size and style are different

—————————————
-Q12
—————————————
--How many skus are in the skuinfo table, 
--but NOT in the skstinfo table?
SELECT COUNT(*)
FROM skuinfo LEFT JOIN skstinfo
ON skuinfo.sku=skstinfo.sku
WHERE skstinfo.sku IS NULL;
-----
SELECT	COUNT(DISTINCT	si.sku)
FROM	skstinfo	st	RIGHT	JOIN	skuinfo	si
ON	st.sku=si.sku
WHERE	st.sku	IS	NULL;
-----
SELECT	COUNT(DISTINCT	si.sku)
FROM	skuinfo	si	LEFT	JOIN	skstinfo	st
ON	si.sku=st.sku
WHERE	st.sku	IS	NULL;
-- 803966

—————————————
-Q13
—————————————
--In what city and state is the store that had the greatest total sum of sales?
SELECT TOP 1 SUM(t.amt) AS total, s.store, s.city, s.state
FROM trnsact t JOIN strinfo s
ON t.store=s.store
WHERE t.stype='P'
GROUP BY s.store, s.city, s.state
ORDER BY total DESC;
-----
SELECT strinfo.city, strinfo.state, T.total_sales
FROM 
	(SELECT trnsact.store AS store, SUM(trnsact.amt) AS total_sales
	FROM trnsact
	GROUP BY trnsact.store) AS T
JOIN strinfo
ON strinfo.store  = T.store
ORDER BY T.total_sales DESC;
-- METAIRIE LA 27058653.42

—————————————
-Q14
—————————————
--Left Join

—————————————
-Q15
—————————————
--How many states have more than 10 Dillards stores in them?
SELECT COUNT(*)
FROM ( SELECT state, COUNT(DISTINCT store) AS num 
       FROM strinfo
       GROUP BY state
       HAVING num > 10) AS states_name;
       
----------
-Q16 
--What is the suggested retail price of all the skus in the “reebok” 
--department with the “sketchers” brand and a “wht/saphire” color?
SELECT sk.retail, d.deptdesc, s.brand, s.color
FROM deptinfo d JOIN skuinfo s ON d.dept = s.dept 
                JOIN skstinfo sk ON sk.sku=s.sku
GROUP BY sk.retail, d.deptdesc, s.brand, s.color
HAVING d.deptdesc='reebok' AND s.brand='skechers' AND s.color='wht/saphire'
****
SELECT skuinfo.sku, skstinfo.retail
FROM skuinfo
JOIN skstinfo
ON skuinfo.sku = skstinfo.sku
JOIN deptinfo
ON skuinfo.dept = deptinfo.dept
WHERE deptinfo.deptdesc = 'reebok' AND skuinfo.brand = 'skechers' AND skuinfo.color = 'wht/saphire'
-- 29
