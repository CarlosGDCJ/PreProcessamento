DROP FUNCTION preProcessa;
CREATE FUNCTION preProcessa ( tabela regclass ) RETURNS VOID AS $$
DECLARE temp text;
BEGIN
    DROP TABLE IF EXISTS unifTeste;
    CREATE TABLE unifTeste (
        inst text COLLATE pg_catalog."default",
        t_rec text COLLATE pg_catalog."default",
        rvaluemin text COLLATE pg_catalog."default",
        rvaluemax text COLLATE pg_catalog."default",
        rvalueavg text COLLATE pg_catalog."default",
        usfluxmin text COLLATE pg_catalog."default",
        usfluxmax text COLLATE pg_catalog."default",
        usfluxavg text COLLATE pg_catalog."default"
    );
    EXECUTE format('SELECT t_rec FROM %s LIMIT 1', tabela)
    INTO temp;
    INSERT INTO unifTeste (t_rec) VALUES (temp);
END;
$$ LANGUAGE plpgsql;
