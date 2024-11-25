CREATE OR REPLACE FUNCTION GET_YEARS_SERVICE(
    employee_id_input INT
)
    RETURNS NUMERIC AS $$
DECLARE
    years_service NUMERIC;
    hire_date_employee DATE;
BEGIN
    IF employee_id_input IS NULL THEN
        RAISE EXCEPTION 'cannot be NULL';
    END IF;

    SELECT e.hire_date INTO hire_date_employee
    FROM employees e
    WHERE e.employee_id = employee_id_input;

    years_service := DATE_PART('year', AGE(CURRENT_DATE, hire_date_employee));

    RETURN years_service;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'not found', employee_id_input;
END;
$$ LANGUAGE plpgsql;


SELECT GET_YEARS_SERVICE(106) AS years_service;
SELECT GET_YEARS_SERVICE(999) AS years_service;
SELECT GET_YEARS_SERVICE(110) AS years_service;
SELECT GET_YEARS_SERVICE(120) AS years_service;
SELECT employee_id, hire_date FROM employees WHERE employee_id = 106;
