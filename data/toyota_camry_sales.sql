CREATE OR REPLACE VIEW TOYOTA_CAMRY_SALES AS
SELECT *
FROM CARPRICES
WHERE make = 'Toyota' AND model = 'Camry'
