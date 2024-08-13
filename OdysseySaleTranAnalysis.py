import pandas as pd
import matplotlib.pyplot as pl

odyssey_sales = pd.read_csv('data/honda_odyssey_sales.csv')
pd.set_option('display.max_columns', None)

odyssey_sales = odyssey_sales[(odyssey_sales['TRIM'] == 'EX')
                              | (odyssey_sales['TRIM'] == 'EX-L')
                              | (odyssey_sales['TRIM'] == 'Touring')]
sale_by_year_trim = odyssey_sales.groupby(['YEAR', 'TRIM']).size()\
    .reset_index(name='sale_count')
sale_by_year_trim = sale_by_year_trim.rename(columns={'YEAR': 'year', 'TRIM': 'trim'})

sale_by_year_trim = sale_by_year_trim[(sale_by_year_trim['year'] >= 2001)]
sale_by_year_trim_pv = sale_by_year_trim.pivot_table(index='year', columns='trim', values='sale_count').fillna(0)
sale_by_year_trim_pv = sale_by_year_trim_pv.astype(int)

ax = sale_by_year_trim_pv.plot.barh(width=0.75, figsize=(12, 8))
for container in ax.containers:
    ax.bar_label(container)
pl.xlabel('Sale Transaction Count')
pl.ylabel('Year')
pl.subplots_adjust(left=0.065, right=0.965, top=0.95, bottom=0.08)
pl.title('Honda Odyssey\'s sale transaction count by year')
pl.show()
