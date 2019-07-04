--Q3:
--On what day was Dillard’s income based on total sum of purchases the greatest?

SELECT saledate, sum(quantity*sprice) as income
FROM trnsact
GROUP BY saledate
ORDER BY income DESC;

SELECT saledate, SUM(amt)
FROM trnsact
WHERE stype = 'P'
GROUP BY saledate
ORDER BY SUM(amt) DESC;
----------------
--Q4:
--What is the deptdesc of the departments that have the 
--top 3 greatest numbers of skus from the skuinfo table 
--associated with them?

SELECT d.DEPT, COUNT(s.sku) AS num, d.deptdesc
FROM deptinfo d INNER JOIN skuinfo s
ON d.dept = s.dept
GROUP BY d.dept, d.deptdesc
ORDER BY num DESC;

SELECT TOP 3 d.deptdesc, COUNT(s.sku)
FROM skuinfo s LEFT JOIN deptinfo d
ON s.dept = d.dept
GROUP BY d.deptdesc
ORDER BY COUNT(s.sku) DESC;
-----------------------------
--Q5:
--Which table contains the most distinct sku numbers?

SELECT DISTINCT COUNT(sku)
FROM ...;

-----------------------------

--Q6:
--How many skus are in the skstinfo table, but NOT in the skuinfo table?

SELECT COUNT(sk.sku)
FROM skuinfo s INNER JOIN skstinfo sk 
ON sk.sku=s.sku;
39230146

SELECT COUNT(sku)
FROM skstinfo;
40034112

SELECT skstinfo.sku
FROM skstinfo LEFT JOIN skuinfo
ON skstinfo.sku = skuinfo.sku
WHERE skuinfo.sku IS NULL
GROUP BY skstinfo.sku; 
------------------------------
--Q7:
--What is the average amount of profit Dillard’s made per day?

SELECT SUM(t.amt - s.cost)/COUNT(DISTINCT t.saledate)
FROM trnsact t LEFT JOIN skstinfo s
ON t.sku=s.sku AND t.store=s.store
WHERE stype = 'P'
--不加t.store=s.store增加执行时间
----------------------------

--Q8:
--The store_msa table provides population statistics about the 
--geographic location around a store. Using one query to retrieve 
--your answer, how many MSAs are there within the state of North 
--Carolina (abbreviated “NC”), and within these MSAs, what is the 
--lowest population level (msa_pop) and highest income level (msa_income)?

SELECT COUNT(msa), MIN(msa_pop),MAX(msa_income), state
FROM store_msa
GROUP BY state
WHERE state = 'NC';
----------------------------
--Q9:
--What department (with department description), brand, style, and color 
--brought in the greatest total amount of sales?

SELECT s.dept, d.deptdesc, s.brand, s.style, s.color, SUM(t.amt) AS sales
FROM skuinfo s LEFT JOIN deptinfo d 
ON d.dept=s.dept
LEFT JOIN trnsact t
ON s.sku=t.sku
GROUP BY s.dept,d.deptdesc, s.brand, s.style, s.color
ORDER BY sales DESC;
----------------------------
--Q10:
--How many stores have more than 180,000 distinct skus associated with 
--them in the skstinfo table?

SELECT store, COUNT(DISTINCT sku)
FROM skstinfo
GROUP BY store
HAVING COUNT(DISTINCT sku) > 180000;

