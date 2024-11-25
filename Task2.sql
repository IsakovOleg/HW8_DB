CREATE OR REPLACE PROCEDURE ADD_JOB_HIST(
    employee_id_input INT,
    new_job_id_input VARCHAR
)
    LANGUAGE plpgsql
AS $$
DECLARE
    current_hire_date DATE;
    new_min_salary NUMERIC;
BEGIN
    SELECT hire_date INTO current_hire_date
    FROM employees
    WHERE employee_id = employee_id_input;

    INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
    SELECT employee_id, hire_date, CURRENT_DATE, job_id, department_id
    FROM employees
    WHERE employee_id = employee_id_input;

    SELECT min_salary INTO new_min_salary
    FROM jobs
    WHERE job_id = new_job_id_input;

    UPDATE employees
    SET hire_date = CURRENT_DATE,
        job_id = new_job_id_input,
        salary = new_min_salary + 500
    WHERE employee_id = employee_id_input;

    RAISE NOTICE 'job history added', employee_id_input, new_job_id_input;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'not found', employee_id_input, new_job_id_input;
END;
$$;
