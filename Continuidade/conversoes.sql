/* template de função
DROP FUNCTION nomeFuncao;
CREATE FUNCTION nomeFuncao ( nomeParam tipoParam ) RETURNS tipoRetorno AS $$
DECLARE nomeVarLocal tipoVarLocal;
BEGIN
    
END;
$$ LANGUAGE plpgsql;
*/

DROP FUNCTION conversoes;
CREATE FUNCTION conversoes () RETURNS void AS $$
DECLARE 
    tempoAntes TEXT;
    tempoDepois TEXT;
    tempoDepoisDepois TEXT;

BEGIN
    SELECT t_rec FROM uniftimestamp LIMIT 1 INTO tempoAntes;
    RAISE NOTICE '%', tempoAntes;
    -- tempoAntes = 2012.10.01_00:00:00_TAI
    SELECT to_timestamp(tempoAntes, 'YYYY.MM.DD_HH24:MI:SS') INTO tempoDepois;
    RAISE NOTICE '%', tempoDepois;
    -- 2012-10-01 00:00:00+00
    SELECT  concat(substring(replace(replace(tempoDepois, '-', '.'), ' ', '_') FROM 1 FOR 19), '_TAI') INTO tempoDepoisDepois;
    RAISE NOTICE '%', tempoDepoisDepois;

END;
$$ LANGUAGE plpgsql;