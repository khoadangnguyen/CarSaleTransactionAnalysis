import pandas as pd
import matplotlib.pyplot as pl

camry_sales = pd.read_csv('data/toyota_camry_sales.csv')
pd.set_option('display.max_columns', None)

camry_sales = camry_sales[(camry_sales['TRIM'] == 'LE')
                          | (camry_sales['TRIM'] == 'XLE')
                          | (camry_sales['TRIM'] == 'SE')]
sale_by_year_trim = camry_sales.groupby(['YEAR', 'TRIM']).size() \
    .reset_index(name='sale_count')
sale_by_year_trim = sale_by_year_trim.rename(columns={'YEAR': 'year', 'TRIM': 'trim'})

sale_by_year_trim = sale_by_year_trim[(sale_by_year_trim['year'] >= 2001)]
sale_by_year_trim_pv = sale_by_year_trim.pivot_table(index='year', columns='trim', values='sale_count').fillna(0)
sale_by_year_trim_pv = sale_by_year_trim_pv.astype(int)

ax = sale_by_year_trim_pv.plot.barh(width=0.75, figsize=(12, 8))
for container in ax.containers:
    ax.bar_label(container, padding=3)
pl.xlabel('Sale Transaction Count')
pl.ylabel('Year')
pl.title('Toyota Camry\'s sale transaction count by year')
pl.subplots_adjust(left=0.065, right=0.965, top=0.95, bottom=0.08)
pl.show()
