DROP TABLE IF EXISTS UnifTeste;
CREATE TABLE UnifTeste (
    t_rec text COLLATE pg_catalog."default",
    rx text COLLATE pg_catalog."default",
    rvaluemin text COLLATE pg_catalog."default",
    rvaluemax text COLLATE pg_catalog."default",
    rvalueavg text COLLATE pg_catalog."default",
    usfluxmin text COLLATE pg_catalog."default",
    usfluxmax text COLLATE pg_catalog."default",
    usfluxavg text COLLATE pg_catalog."default",
    classemin text COLLATE pg_catalog."default",
    classemax text COLLATE pg_catalog."default"
);

DROP FUNCTION IF EXISTS preProcessa;
CREATE FUNCTION preProcessa ( tabela regclass ) RETURNS VOID AS $$
DECLARE 
    temp TEXT;
    rvmin TEXT;
    rvmax TEXT;
    rvavg TEXT;
    ufmin TEXT;
    ufmax TEXT;
    ufavg TEXT;
    clmin TEXT;
    clmax TEXT;
    curs refcursor;
BEGIN
    OPEN curs FOR EXECUTE format('SELECT DISTINCT t_rec FROM %s ORDER BY t_rec', tabela);
    LOOP
        FETCH curs INTO temp;
        EXIT WHEN NOT FOUND;

        EXECUTE format('
            CREATE OR REPLACE VIEW Intervalo AS 
            SELECT t_rec, noaa_ar, xray1 , xray2 , xray3 , xray4 , xray5 , xray6 , xray7 , xray8 , xray9 , xray10 , xray11, xray12, r_value, usflux, class 
            FROM %s WHERE ''%s'' LIKE t_rec
            ', tabela, temp);

        SELECT to_char(MIN(NULLIF(NULLIF(r_value::numeric, 0), 'NaN')),'FM999D00') FROM Intervalo INTO rvmin;
        SELECT to_char(MAX(NULLIF(NULLIF(r_value::numeric, 0), 'NaN')),'FM999D00') FROM Intervalo INTO rvmax;
        SELECT to_char(AVG(NULLIF(NULLIF(r_value::numeric, 0), 'NaN')),'FM999D00') FROM Intervalo INTO rvavg;

        SELECT to_char(MIN(usflux::numeric), '9.9999EEEE') FROM Intervalo INTO ufmin;
        SELECT to_char(MAX(usflux::numeric), '9.9999EEEE') FROM Intervalo INTO ufmax;
        SELECT to_char(AVG(usflux::numeric), '9.9999EEEE') FROM Intervalo INTO ufavg;

        SELECT MIN(class) FROM Intervalo INTO clmin;
        SELECT MAX(class) FROM Intervalo INTO clmax;


        IF (temp LIKE '%00:00_TAI') THEN

            INSERT INTO UnifTeste (t_rec, rx, rvaluemin, rvaluemax, rvalueavg, usfluxmin, usfluxmax, usfluxavg, classemin, classemax) 
            VALUES  (temp, (SELECT xray1 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '01:00_TAI', (SELECT xray2 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '02:00_TAI', (SELECT xray3 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '03:00_TAI', (SELECT xray4 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '04:00_TAI', (SELECT xray5 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '05:00_TAI', (SELECT xray6 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '06:00_TAI', (SELECT xray7 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '07:00_TAI', (SELECT xray8 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '08:00_TAI', (SELECT xray9 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '09:00_TAI', (SELECT xray10 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '10:00_TAI', (SELECT xray11 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '11:00_TAI', (SELECT xray12 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax);

        ELSIF (temp LIKE '%12:00_TAI') THEN
            INSERT INTO UnifTeste (t_rec, rx, rvaluemin, rvaluemax, rvalueavg, usfluxmin, usfluxmax, usfluxavg, classemin, classemax) 
            VALUES  (temp, (SELECT xray1 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '13:00_TAI', (SELECT xray2 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '14:00_TAI', (SELECT xray3 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '15:00_TAI', (SELECT xray4 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '16:00_TAI', (SELECT xray5 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '17:00_TAI', (SELECT xray6 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '18:00_TAI', (SELECT xray7 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '19:00_TAI', (SELECT xray8 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '20:00_TAI', (SELECT xray9 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '21:00_TAI', (SELECT xray10 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '22:00_TAI', (SELECT xray11 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '23:00_TAI', (SELECT xray12 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax);
            
        ELSIF (temp LIKE '%24:00_TAI') THEN
            INSERT INTO UnifTeste (t_rec, rx, rvaluemin, rvaluemax, rvalueavg, usfluxmin, usfluxmax, usfluxavg, classemin, classemax) 
            VALUES  (temp, (SELECT xray1 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '25:00_TAI', (SELECT xray2 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '26:00_TAI', (SELECT xray3 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '27:00_TAI', (SELECT xray4 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '28:00_TAI', (SELECT xray5 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '29:00_TAI', (SELECT xray6 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '30:00_TAI', (SELECT xray7 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '31:00_TAI', (SELECT xray8 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '32:00_TAI', (SELECT xray9 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '33:00_TAI', (SELECT xray10 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '34:00_TAI', (SELECT xray11 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '35:00_TAI', (SELECT xray12 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax);
        ELSIF (temp LIKE '%36:00_TAI') THEN
            INSERT INTO UnifTeste (t_rec, rx, rvaluemin, rvaluemax, rvalueavg, usfluxmin, usfluxmax, usfluxavg, classemin, classemax) 
            VALUES  (temp, (SELECT xray1 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '37:00_TAI', (SELECT xray2 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '38:00_TAI', (SELECT xray3 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '39:00_TAI', (SELECT xray4 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '40:00_TAI', (SELECT xray5 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '41:00_TAI', (SELECT xray6 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '42:00_TAI', (SELECT xray7 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '43:00_TAI', (SELECT xray8 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '44:00_TAI', (SELECT xray9 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '45:00_TAI', (SELECT xray10 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '46:00_TAI', (SELECT xray11 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '47:00_TAI', (SELECT xray12 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax);
        ELSIF (temp LIKE '%48:00_TAI') THEN
            INSERT INTO UnifTeste (t_rec, rx, rvaluemin, rvaluemax, rvalueavg, usfluxmin, usfluxmax, usfluxavg, classemin, classemax) 
            VALUES  (temp, (SELECT xray1 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '49:00_TAI', (SELECT xray2 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '50:00_TAI', (SELECT xray3 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '51:00_TAI', (SELECT xray4 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '52:00_TAI', (SELECT xray5 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '53:00_TAI', (SELECT xray6 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '54:00_TAI', (SELECT xray7 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '55:00_TAI', (SELECT xray8 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '56:00_TAI', (SELECT xray9 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '57:00_TAI', (SELECT xray10 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '58:00_TAI', (SELECT xray11 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax),
                    (substring(temp, 1, 14) || '59:00_TAI', (SELECT xray12 FROM Intervalo LIMIT 1), rvmin, rvmax, rvavg, ufmin, ufmax, ufavg, clmin, clmax);
        END IF;
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
