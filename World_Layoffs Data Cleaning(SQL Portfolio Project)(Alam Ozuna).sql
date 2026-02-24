select *
from layoffs ;


# 1. remove duplicates
# 2. Standarized the data
# 3. null values or blank values
# 4. remove any columns

CREATE TABLE layoffs_staging
Like layoffs ; 

-- REMOVING DUPLICATES

select *
from layoffs_staging ;

SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, industry, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging;

insert layoffs_staging
select *
from layoffs;


WITH duplicate_cte AS
(
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, stage, country, funds_raised_millions, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging
)
SELECT *
FROM duplicate_cte
WHERE row_num > 1;

select *
from layoffs_staging
where company = 'Casper' ;

CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

select *
from layoffs_staging2 ;

Insert into layoffs_staging2
SELECT *,
ROW_NUMBER() OVER(
PARTITION BY company, location, stage, country, funds_raised_millions, total_laid_off, percentage_laid_off, `date`) AS row_num
FROM layoffs_staging ; 

delete
from layoffs_staging2
where row_num > 1;

select *
from layoffs_staging2
where row_num > 1;

-- STANDARIZING DATA

select company, trim(company)
from layoffs_staging2 ;

update layoffs_staging2
set company = TRIM(company) ;

select distinct industry
from layoffs_staging2 
order by 1;

select *
from layoffs_staging2
where industry like 'Crypto%' ;

Update layoffs_staging2
set industry = 'Crypto'
where industry like 'Crypto%' ;

select distinct country
from layoffs_staging2 
order by 1;

Update layoffs_staging2
set country = 'United States'
where country like 'United States.' ;

select distinct country
from layoffs_staging2 ;

select `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
from layoffs_staging2;

Update layoffs_staging2
Set `date` = STR_TO_DATE(`date`, '%m/%d/%Y') ;


select `date`
from layoffs_staging2; 

alter table layoffs_staging2
modify column `date` date ;

select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null; 

select *
from layoffs_staging2
where industry is null
or industry = '' ;

Update layoffs_staging2
set industry = null
where industry = "";

SELECT t1.industry, t2.industry
FROM layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '')
AND t2.industry IS NOT NULL;

UPDATE layoffs_staging2 t1
JOIN layoffs_staging2 t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL
AND t2.industry IS NOT NULL;

select *
from layoffs_staging2
where company = 'Airbnb' ; 


select *
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null; 


Delete
from layoffs_staging2
where total_laid_off is null
and percentage_laid_off is null; 

select *
from layoffs_staging2; 

alter table layoffs_staging2
drop column row_num ;