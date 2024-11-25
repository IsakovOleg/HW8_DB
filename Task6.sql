CREATE OR REPLACE FUNCTION CHECK_SALARY_RANGE()
    RETURNS TRIGGER AS $$
DECLARE
    invalid_employee RECORD;
BEGIN
    SELECT *
    INTO invalid_employee
    FROM employees
    WHERE job_id = NEW.job_id
      AND (salary < NEW.min_salary OR salary > NEW.max_salary)
    LIMIT 1;

    IF FOUND THEN
        RAISE EXCEPTION 'outside the range',
            NEW.job_id, invalid_employee.employee_id, invalid_employee.salary, NEW.min_salary, NEW.max_salary;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER CHECK_SAL_RANGE
    BEFORE UPDATE OF min_salary, max_salary
    ON jobs
    FOR EACH ROW
EXECUTE FUNCTION CHECK_SALARY_RANGE();

UPDATE jobs
SET min_salary = 6000, max_salary = 12000
WHERE job_id = 'SY_ANAL';

UPDATE jobs
SET min_salary = 9000
WHERE job_id = 'SY_ANAL';

SELECT employee_id, salary, job_id
FROM employees
WHERE job_id = 'SY_ANAL';

SELECT job_id, min_salary, max_salary
FROM jobs
WHERE job_id = 'SY_ANAL';
