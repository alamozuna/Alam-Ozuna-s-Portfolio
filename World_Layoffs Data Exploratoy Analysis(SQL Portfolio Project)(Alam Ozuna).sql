-- Exploratory Data Analysis

select *
from layoffs_staging2; 

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2 ; 

select *
from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc ;

select *
from layoffs_staging2
where percentage_laid_off = 1
order by funds_raised_millions desc ;

select company, sum(total_laid_off)
from layoffs_staging2
group by company
order by 2 desc ;

select min(`date`), max(`date`)
from layoffs_staging2 ;

select industry, sum(total_laid_off)
from layoffs_staging2
group by industry
order by 2 desc ;

select country, sum(total_laid_off)
from layoffs_staging2
group by country
order by 2 desc ;

select year(`date`), sum(total_laid_off)
from layoffs_staging2
group by year(`date`)
order by 1 desc ;

select stage, sum(total_laid_off)
from layoffs_staging2
group by stage
order by 2 desc ;

SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off)
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) AS `MONTH`, SUM(total_laid_off) AS total_off
FROM layoffs_staging2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_off
,SUM(total_off) OVER(ORDER BY `MONTH`) AS rolling_total
FROM Rolling_Total;

select company, year(`date`), sum(total_laid_off)
from layoffs_staging2
group by company, year(`date`)
order by 3 desc ;

WITH Company_Year (company, years, total_laid_off) AS
(
SELECT company, YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY company, YEAR(`date`)
), company_year_rank as
(SELECT *, 
DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) as ranking
FROM Company_Year
WHERE years IS NOT NULL
)
select *
from company_year_rank
where ranking <= 5;