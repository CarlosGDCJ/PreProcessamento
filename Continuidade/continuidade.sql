/* template de função
DROP FUNCTION nomeFuncao;
CREATE FUNCTION nomeFuncao ( nomeParam tipoParam ) RETURNS tipoRetorno AS $$
DECLARE nomeVarLocal tipoVarLocal;
BEGIN
    
END;
$$ LANGUAGE plpgsql;
*/

DROP FUNCTION continuidade;
CREATE FUNCTION continuidade ( tabela regclass ) RETURNS VOID AS $$
DECLARE 
    t1 TIMESTAMP WITH TIME ZONE;
    t2 TIMESTAMP WITH TIME ZONE;
    curs refcursor;
BEGIN
    OPEN curs FOR EXECUTE format('SELECT t_rec FROM %s ORDER BY t_rec', tabela);
    LOOP
        FETCH curs INTO t1;
        -- RAISE NOTICE '%', t1;
        FETCH curs INTO t2;
        EXIT WHEN NOT FOUND;
        -- RAISE NOTICE '%', t2;    

        WHILE (t1 + INTERVAL '1 minute' <> t2) LOOP
            SELECT t1 + INTERVAL '1 minute' INTO t1;
            EXECUTE format('
            INSERT INTO %s (t_rec, rx, rvaluemin, rvaluemax, rvalueavg, usfluxmin, usfluxmax, usfluxavg, classemin, classemax)
            VALUES (''%s'', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
            ', tabela, t1);
            RAISE NOTICE 'T1: % T2: %', t1, t2;
        END LOOP;
        MOVE BACKWARD FROM curs;
        -- RAISE NOTICE 'Acabou uma iteracao';
        
    END LOOP;
    CLOSE curs;
END;
$$ LANGUAGE plpgsql;