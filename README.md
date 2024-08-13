# Car Sale Transaction Analysis
Analyze car sale transaction data to come up with training data and test data for Regression model

### Description
This project is to analyze over 500,000 car sale transactions of 96 car makes, 972 models, and 1963 trims from 1982 
to 2015 to come up with what car make, model, trim, and year can be used for training data and test data for the
Regression model to predict car sale price

### Result
The analysis results in some popular car make, model, and trim having continuous car sale transaction from 2001 to 2015
(15 years). Two of these are the Toyota Camry (LE, SE, and XLE) and Honda Odyssey (EX, EX-L, and Touring), and the 
results are plotted with Matplotlib as below.

![Toyota_Camry_Sale_Transaction](image/Toyota_Camry_Sale_Transaction.png)

![Honda_Odyssey_Sale_Transaction](image/Honda_Odyssey_Sale_Transaction.png)

### Solution
One approach was to look at a car make and summarize all sale transactions grouped by model, trim, and year then look 
for all sale transactions of each model and trim to find years with continuous sale transactions. The implementation of 
this approach can be done by SQL query (data/toyota_model_trim_sales_by_year.sql), and example result as below table.

| MODEL | TRIM | Y2000 | Y2001 | Y2002 | Y2003 | Y2004 | Y2005 | Y2006 | Y2007 | Y2008 | Y2009 | Y2010 | Y2011 | Y2012 | Y2013 | Y2014 | Y2015 |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
 | ... |
| Camry | LE | 80 | 25 | 179 | 168 | 120 | 154 | 89 | 377 | 143 | 358 | 211 | 532 | 1221 | 710 | 1296 | 11 |
| Camry | SE | 0 | 0 | 17 | 18 | 13 | 56 | 10 | 56 | 25 | 57 | 67 | 160 | 1218 | 752 | 1639 | 34 |
| Camry | XLE | 0 | 0 | 27 | 38 | 21 | 18 | 40 | 55 | 58 | 28 | 22 | 75 | 413 | 42 | 41 | 0 |
 | ... |

The result can then be used to visualize as in the previous 2 bar charts.

This approach can be applied to any other car make, and the result satisfies the analysis goal in order to prepare
data for implementing Regression model.

### Extension and Generalization
However, an interesting problem to solve with SQL is how to find any car make, model, and trim that satisfies the
condition of continuous car sales over years given the dataset of over 500,000 sale transactions of 96 car makes, 
972 models, and 1963 trims from 1982 to 2015.

The solution of this problem is implemented in SQL (data/make_model_trim_with_7_consecutive_years_and_above_sale.sql), 
and the results are exported in CSV file (data/make_model_trim_with_7_consecutive_years_and_above_sale.csv).
Example as below table.

| MAKE | MODEL | TRIM | START_YEAR | END_YEAR | YEAR_COUNT |
| --- | --- | --- | --- | --- | --- |
 | ... |
| Toyota | Camry | LE | 1992 | 2015 | 24 |
| Honda | Odyssey | EX | 2001 | 2014 | 14 |
| Jeep | Grand Cherokee | Limited | 1997 | 2015 | 19 |
| Ford | F-150 | XL | 1993 | 2014 | 22 |
 | ... |

The implementation is to find car make, model, and trim having minimum of 7 years of continuous sales. In the example
result above, the first 3 columns are MAKE, MODEL, and TRIM for car make, model, and trim satisfied the condition. 
START_YEAR is the starting year of the continuous sale with positive number of sale transaction, END_YEAR is the ended 
year of the consecutive positive number of sale transactions, and YEAR_COUNT is the count of the continuous years.

With this approach, it is easier to choose a make, model, and trim to further analyze for the minimum number of  sale 
transaction data and decide if chosen the make, model, and trim can be used to create training data set as well as test 
data set for that make, model, and trim. 
In fact, with the implemented solution, the number of minimum sale transactions can be easily added to existing code to 
filter out make, model, and trim having number of sale transactions that is smaller than a given number.



