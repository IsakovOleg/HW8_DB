CREATE OR REPLACE PROCEDURE UPD_JOBSAL(
    job_id_input VARCHAR,
    new_min_salary NUMERIC,
    new_max_salary NUMERIC
)
    LANGUAGE plpgsql
AS $$
BEGIN
    IF new_max_salary < new_min_salary THEN
        RAISE EXCEPTION 'exception',
            new_max_salary, new_min_salary;
    END IF;

    UPDATE jobs
    SET min_salary = new_min_salary, max_salary = new_max_salary
    WHERE job_id = job_id_input;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'not found', job_id_input;
    END IF;

    RAISE NOTICE 'updated',
        job_id_input, new_min_salary, new_max_salary;
EXCEPTION
    WHEN SQLSTATE '55P03' THEN
        RAISE EXCEPTION 'exception';
END;
$$;
