WITH
	make_model_trims AS (
		SELECT DISTINCT make, model, trim
		FROM CARPRICES),

	existing_years AS (
		SELECT DISTINCT year
		FROM CARPRICES),

	extra_year AS (
		SELECT (MAX(year) + 1) AS year
		FROM existing_years
	),

	years AS (
		SELECT year
		FROM existing_years
		UNION ALL
		SELECT year
		FROM extra_year
	),

	make_model_trim_years AS (
		SELECT make, model, trim, year
		FROM make_model_trims mmt, years y
	),

	make_model_trim_allyear_sales AS (
		SELECT
			mmty.make,
			mmty.model,
			mmty.trim,
			mmty.year,
			COUNT(cp.vin) AS number_of_sales
		FROM make_model_trim_years mmty
			LEFT JOIN CARPRICES cp ON
				mmty.make = cp.make
				AND mmty.model = cp.model
				AND mmty.trim = cp.trim
				AND mmty.year = cp.year
		GROUP BY mmty.make, mmty.model, mmty.trim, mmty.year
	),

	make_model_trim_year_future_year_with_zero_sale AS (
		SELECT
			a.make,
			a.model,
			a.trim,
			a.year year_with_non_zero_sale,
			a.number_of_sales non_zero_sale,
			b.year future_year_with_zero_sale,
			b.number_of_sales zero_sale
		FROM make_model_trim_allyear_sales a
			LEFT JOIN make_model_trim_allyear_sales b
				ON a.make = b.make
				AND a.model = b.model
				AND a.trim = b.trim
				AND a.year < b.year
		WHERE a.number_of_sales != 0 AND b.number_of_sales = 0
	),

	make_model_trim_year_next_year_with_zero_sale AS (
		SELECT
			make,
			model,
			trim,
			year_with_non_zero_sale,
			MIN(future_year_with_zero_sale) next_year_with_zero_sale
		FROM make_model_trim_year_future_year_with_zero_sale
		GROUP BY make, model, trim, year_with_non_zero_sale
	),

	make_model_trim_year_consecutive_number AS (
		SELECT
			make,
			model,
			trim,
			year_with_non_zero_sale,
			next_year_with_zero_sale,
			(next_year_with_zero_sale - year_with_non_zero_sale) consecutive_number
		FROM make_model_trim_year_next_year_with_zero_sale
	),

	make_model_trim_year_max_consecutive_number_by_year AS (
		SELECT
			make,
			model,
			trim,
			year_with_non_zero_sale,
			MAX(consecutive_number) longest_consecutive_number
		FROM make_model_trim_year_consecutive_number
		GROUP BY make, model, trim, year_with_non_zero_sale
	),

	make_model_trim_max_consecutive_number AS (
		SELECT
			make,
			model,
			trim,
			MAX(longest_consecutive_number) longest_consecutive_number
		FROM make_model_trim_year_max_consecutive_number_by_year
		GROUP BY make, model, trim
	),

	make_model_trim_year_with_longest_consecutive_sale AS (
		SELECT
			a.make,
			a.model,
			a.trim,
			a.year_with_non_zero_sale,
			a.longest_consecutive_number
		FROM make_model_trim_year_max_consecutive_number_by_year a
			JOIN make_model_trim_max_consecutive_number b
				ON a.make = b.make
				AND a.model = b.model
				AND a.trim = b.trim
				and a.longest_consecutive_number = b.longest_consecutive_number
	),

	make_model_trim_at_least_7_year_of_consecutive_sale AS (
		SELECT
			make,
			model,
			trim,
			year_with_non_zero_sale,
			next_year_with_zero_sale,
			consecutive_number
		FROM make_model_trim_year_consecutive_number
		WHERE consecutive_number >= 7
	)

SELECT
	make,
	model,
	trim,
	(next_year_with_zero_sale - consecutive_number) start_year,
	(next_year_with_zero_sale - 1) end_year,
	consecutive_number year_count
FROM (
	SELECT
		make,
		model,
		trim,
		next_year_with_zero_sale,
		MAX(consecutive_number) consecutive_number
	FROM make_model_trim_at_least_7_year_of_consecutive_sale
	GROUP BY make, model, trim, next_year_with_zero_sale
	) a
ORDER BY make, model, trim
