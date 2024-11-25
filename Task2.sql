CREATE OR REPLACE PROCEDURE ADD_JOB_HIST(
    employee_id_input INT,
    new_job_id_input VARCHAR
)
    LANGUAGE plpgsql
AS $$
DECLARE
    current_hire_date DATE;
    new_min_salary NUMERIC;
    trimmed_job_id VARCHAR(10);
BEGIN
    SELECT hire_date INTO current_hire_date
    FROM employees
    WHERE employee_id = employee_id_input;

    trimmed_job_id := LEFT(new_job_id_input, 10);

    IF NOT EXISTS (
        SELECT 1
        FROM jobs
        WHERE job_id = trimmed_job_id
    ) THEN
        RAISE EXCEPTION 'not exist', trimmed_job_id;
    END IF;

    IF NOT EXISTS (
        SELECT 1
        FROM job_history
        WHERE employee_id = employee_id_input AND start_date = current_hire_date
    ) THEN
        INSERT INTO job_history (employee_id, start_date, end_date, job_id, department_id)
        SELECT employee_id, hire_date, CURRENT_DATE + INTERVAL '1 day', job_id, department_id
        FROM employees
        WHERE employee_id = employee_id_input;
    END IF;

    SELECT min_salary INTO new_min_salary
    FROM jobs
    WHERE job_id = trimmed_job_id;

    UPDATE employees
    SET hire_date = CURRENT_DATE,
        job_id = trimmed_job_id,
        salary = new_min_salary + 500
    WHERE employee_id = employee_id_input;

    RAISE NOTICE 'history updated', employee_id_input, trimmed_job_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE EXCEPTION 'not found', employee_id_input, trimmed_job_id;
END;
$$;

CALL ADD_JOB_HIST(106, 'SY_ANAL');
CALL ADD_JOB_HIST(999, 'SY_ANAL');
CALL ADD_JOB_HIST(106, 'INVALID_JOB');
SELECT * FROM job_history WHERE employee_id = 106;

ALTER TABLE employees DISABLE TRIGGER ALL;
ALTER TABLE job_history DISABLE TRIGGER ALL;
CALL ADD_JOB_HIST(106, 'SY_ANAL');
ALTER TABLE employees ENABLE TRIGGER ALL;
ALTER TABLE job_history ENABLE TRIGGER ALL;
