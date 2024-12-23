CREATE OR REPLACE FUNCTION GET_JOB_COUNT(
    employee_id_input INT
)
    RETURNS INT AS $$
DECLARE
    job_count INT;
BEGIN
    IF employee_id_input IS NULL THEN
        RAISE EXCEPTION 'cannot be NULL';
    END IF;

    SELECT COUNT(DISTINCT job_id)
    INTO job_count
    FROM (
             SELECT job_id
             FROM job_history
             WHERE employee_id = employee_id_input

             UNION

             SELECT job_id
             FROM employees
             WHERE employee_id = employee_id_input
         ) unique_jobs;

    IF job_count = 0 THEN
        RAISE EXCEPTION 'not found', employee_id_input;
    END IF;

    RETURN job_count;
END;
$$ LANGUAGE plpgsql;


SELECT GET_JOB_COUNT(176) AS job_count;
SELECT GET_JOB_COUNT(106) AS job_count;
SELECT GET_JOB_COUNT(999) AS job_count;
SELECT * FROM job_history WHERE employee_id = 176;
