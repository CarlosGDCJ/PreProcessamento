DROP TABLE IF EXISTS UnifTeste;
CREATE TABLE UnifTeste (
    t_rec TEXT,
    rx NUMERIC,
    rvaluemin NUMERIC,
    rvaluemax NUMERIC,
    rvalueavg NUMERIC,
    usfluxmin NUMERIC,
    usfluxmax NUMERIC,
    usfluxavg NUMERIC,
    classemin TEXT,
    classemax TEXT
);

DROP INDEX IF EXISTS unif_idx;
CREATE INDEX unif_idx ON UnifTeste(t_rec);

DROP FUNCTION IF EXISTS preProcessa;
CREATE FUNCTION preProcessa ( tabela regclass ) RETURNS VOID AS $$
DECLARE 
    temp TEXT;
    rvmin NUMERIC;
    rvmax NUMERIC;
    rvavg NUMERIC;
    ufmin NUMERIC;
    ufmax NUMERIC;
    ufavg NUMERIC;
    axray1 NUMERIC;
    axray2 NUMERIC;
    axray3 NUMERIC;
    axray4 NUMERIC;
    axray5 NUMERIC;
    axray6 NUMERIC;
    axray7 NUMERIC;
    axray8 NUMERIC;
    axray9 NUMERIC;
    axray10 NUMERIC;
    axray11 NUMERIC;
    axray12 NUMERIC;
    clmin TEXT;
    clmax TEXT;
    curs refcursor;
BEGIN
    TRUNCATE TABLE UnifTeste;
    OPEN curs FOR EXECUTE format('SELECT DISTINCT t_rec FROM %s ORDER BY t_rec', tabela);
    LOOP
        FETCH curs INTO temp;
        EXIT WHEN NOT FOUND;

        EXECUTE format('
            CREATE OR REPLACE VIEW Intervalo AS 
            SELECT t_rec, noaa_ar, xray1 , xray2 , xray3 , xray4 , xray5 , xray6 , xray7 , xray8 , xray9 , xray10 , xray11, xray12, r_value, usflux, class 
            FROM %s WHERE ''%s'' LIKE t_rec
            ', tabela, temp);

        SELECT MIN(NULLIF(NULLIF(r_value, 0), 'NaN')) FROM Intervalo INTO rvmin;
        SELECT MAX(NULLIF(NULLIF(r_value, 0), 'NaN')) FROM Intervalo INTO rvmax;
        SELECT AVG(NULLIF(NULLIF(r_value, 0), 'NaN')) FROM Intervalo INTO rvavg;

        SELECT MIN(usflux) FROM Intervalo INTO ufmin;
        SELECT MAX(usflux) FROM Intervalo INTO ufmax;
        SELECT AVG(usflux) FROM Intervalo INTO ufavg;

        SELECT MIN(class) FROM Intervalo INTO clmin;
        SELECT MAX(class) FROM Intervalo INTO clmax;

        SELECT xray1, xray2, xray3, xray4, xray5, xray6, xray7, xray8, xray9, xray10, xray11, xray12 
        FROM Intervalo LIMIT 1 
        INTO axray1, axray2, axray3, axray4, axray5, axray6, axray7, axray8, axray9, axray10, axray11, axray12;


        IF (temp LIKE '%00:00_TAI') THEN

            INSERT INTO UnifTeste (t_rec, rx, rvaluemin, rvaluemax, rvalueavg, usfluxmin, usfluxmax, usfluxavg, classemin, classemax) 
            VALUES  (temp, axray1, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '01:00_TAI', axray2, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '02:00_TAI', axray3, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '03:00_TAI', axray4, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '04:00_TAI', axray5, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '05:00_TAI', axray6, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '06:00_TAI', axray7, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '07:00_TAI', axray8, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '08:00_TAI', axray9, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '09:00_TAI', axray10, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '10:00_TAI', axray11, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '11:00_TAI', axray12, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax);

        ELSIF (temp LIKE '%12:00_TAI') THEN
            INSERT INTO UnifTeste (t_rec, rx, rvaluemin, rvaluemax, rvalueavg, usfluxmin, usfluxmax, usfluxavg, classemin, classemax) 
            VALUES  (temp, axray1, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '13:00_TAI', axray2, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '14:00_TAI', axray3, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '15:00_TAI', axray4, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '16:00_TAI', axray5, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '17:00_TAI', axray6, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '18:00_TAI', axray7, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '19:00_TAI', axray8, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '20:00_TAI', axray9, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '21:00_TAI', axray10, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '22:00_TAI', axray11, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '23:00_TAI', axray12, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax);
            
        ELSIF (temp LIKE '%24:00_TAI') THEN
            INSERT INTO UnifTeste (t_rec, rx, rvaluemin, rvaluemax, rvalueavg, usfluxmin, usfluxmax, usfluxavg, classemin, classemax) 
            VALUES  (temp, axray1, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '25:00_TAI', axray2, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '26:00_TAI', axray3, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '27:00_TAI', axray4, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '28:00_TAI', axray5, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '29:00_TAI', axray6, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '30:00_TAI', axray7, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '31:00_TAI', axray8, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '32:00_TAI', axray9, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '33:00_TAI', axray10, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '34:00_TAI', axray11, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '35:00_TAI', axray12, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax);
        ELSIF (temp LIKE '%36:00_TAI') THEN
            INSERT INTO UnifTeste (t_rec, rx, rvaluemin, rvaluemax, rvalueavg, usfluxmin, usfluxmax, usfluxavg, classemin, classemax) 
            VALUES  (temp, axray1, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '37:00_TAI', axray2, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '38:00_TAI', axray3, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '39:00_TAI', axray4, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '40:00_TAI', axray5, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '41:00_TAI', axray6, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '42:00_TAI', axray7, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '43:00_TAI', axray8, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '44:00_TAI', axray9, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '45:00_TAI', axray10, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '46:00_TAI', axray11, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '47:00_TAI', axray12, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax);
        ELSIF (temp LIKE '%48:00_TAI') THEN
            INSERT INTO UnifTeste (t_rec, rx, rvaluemin, rvaluemax, rvalueavg, usfluxmin, usfluxmax, usfluxavg, classemin, classemax) 
            VALUES  (temp, axray1, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '49:00_TAI', axray2, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '50:00_TAI', axray3, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '51:00_TAI', axray4, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '52:00_TAI', axray5, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '53:00_TAI', axray6, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '54:00_TAI', axray7, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '55:00_TAI', axray8, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '56:00_TAI', axray9, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '57:00_TAI', axray10, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '58:00_TAI', axray11, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '59:00_TAI', axray12, rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax);
        END IF;

        EXECUTE format('DELETE FROM %s WHERE t_rec LIKE (SELECT t_rec FROM Intervalo LIMIT 1)', tabela);
    END LOOP;
    CLOSE curs;

END;
$$ LANGUAGE plpgsql;


/* Template de função
DROP FUNCTION nomeFuncao;
CREATE FUNCTION nomeFuncao ( nomeParam tipoParam ) RETURNS tipoRetorno AS $$
DECLARE nomeVarLocal tipoVarLocal;
BEGIN
    
END;
$$ LANGUAGE plpgsql;
*/