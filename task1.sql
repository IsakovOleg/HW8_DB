CREATE OR REPLACE PROCEDURE NEW_JOB(
    new_job_id VARCHAR,
    new_job_title VARCHAR,
    new_min_salary NUMERIC
)
    LANGUAGE plpgsql
AS $$
DECLARE
    max_salary_value NUMERIC;
    is_existing_job BOOLEAN;
BEGIN
    IF new_job_id IS NULL OR new_job_title IS NULL OR new_min_salary IS NULL THEN
        RAISE EXCEPTION 'cannot be NULL',
            new_job_id, new_job_title, new_min_salary;
    END IF;

    SELECT EXISTS (
        SELECT 1 FROM jobs WHERE job_id = new_job_id
    ) INTO is_existing_job;

    IF is_existing_job THEN
        RAISE NOTICE 'already exist', new_job_id;

        UPDATE jobs
        SET job_title = new_job_title,
            min_salary = new_min_salary,
            max_salary = new_min_salary * 2
        WHERE job_id = new_job_id;

    ELSE
        max_salary_value := new_min_salary * 2;

        INSERT INTO jobs (job_id, job_title, min_salary, max_salary)
        VALUES (new_job_id, new_job_title, new_min_salary, max_salary_value);

        RAISE NOTICE 'added', new_job_id;
    END IF;
END;
$$;


CALL NEW_JOB('DEV_ENG', 'Development Engineer', 7000);
CALL NEW_JOB('SY_ANAL', 'Updated Analyst', 8000);
CALL NEW_JOB(NULL, 'Invalid Job', 5000);
SELECT * FROM jobs WHERE job_id IN ('DEV_ENG', 'SY_ANAL');
