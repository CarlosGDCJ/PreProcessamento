-- Importa extensão tablefunc para usar função crosstab
CREATE EXTENSION IF NOT EXISTS tablefunc;

-- Function que cria colunas de usflux e rvalue para cada região ativa da tabela gerada pela preProcessa2
DROP FUNCTION IF EXISTS criaColunasRegioesAtivas;
CREATE FUNCTION criaColunasRegioesAtivas (tabela regclass) RETURNS VOID AS $Q$
DECLARE 
    temp text[]; -- vetor que armazena nomes das regiões ativas
    ARnumber integer; -- número de regiões ativas
    nomeaux text; -- variável auxiliar para nomear colunas criadas
BEGIN
    -- Cria view com as regiões ativas enumeradas por ROW_NUMBER, conta quantas são no total e coloca valor em ARnumber
    EXECUTE format('CREATE OR REPLACE VIEW Active_regions AS SELECT noaa_ar, ROW_NUMBER() OVER(ORDER BY noaa_ar) FROM %s GROUP BY noaa_ar', tabela);
    ARnumber = (SELECT COUNT(*) FROM Active_regions);
    
    -- Coloca no vetor temp o nome de cada uma das regiões ativas
    FOR i IN 1..Arnumber LOOP
        temp[i] = (SELECT noaa_ar FROM Active_regions WHERE ROW_NUMBER = i);
    END LOOP;

    -- Para cada região ativa
    FOR i IN 1..Arnumber LOOP
        -- Cria view com a coluna de usflux da região ativa usando a função crosstab       
        DROP VIEW IF EXISTS crossTabUsflux;
        EXECUTE format('
                    CREATE VIEW crossTabUsflux AS
                    SELECT * FROM crosstab(
                                ''SELECT t_rec, noaa_ar, usflux
                                FROM %s 
                                ORDER BY 1,2 ''  
                                , $$VALUES (''%s'')$$
                        ) AS usflux ("t_rec" text, "%s" text)
                    ', tabela, temp[i], temp[i]
                );
        -- Cria nome da nova coluna
        nomeaux = 'RA'||temp[i]||'_Usflux';
        -- Cria nova coluna nula em tabela com o nome recém criado
        EXECUTE format('ALTER TABLE %s ADD COLUMN IF NOT EXISTS %s TEXT', tabela, nomeaux);
        -- Para cada linha, atualiza o valor da coluna recém criada em tabela de acordo com valores da view crossTabUsflux
        EXECUTE format('UPDATE %s SET %s = (SELECT usflux FROM crossTabUsflux WHERE %s.t_rec = crossTabUsflux.t_rec AND %s.noaa_ar = ''%s'')'
                        , tabela, nomeaux, tabela, tabela, temp[i]
                      );
        
        -- O que se faz para o usflux é feito de forma análoga para o rvalue
        DROP VIEW IF EXISTS crossTabRvalue;
        EXECUTE format('
                    CREATE VIEW crossTabRvalue AS
                    SELECT * FROM crosstab(
                                ''SELECT t_rec, noaa_ar, rvalue
                                FROM %s 
                                ORDER BY 1,2 ''  
                                , $$VALUES (''%s'')$$
                        ) AS rvalue ("t_rec" text, "%s" text)
                    ', tabela, temp[i], temp[i]
                );
        nomeaux = 'RA'||temp[i]||'_Rvalue';
        EXECUTE format('ALTER TABLE %s ADD COLUMN IF NOT EXISTS %s TEXT', tabela, nomeaux);
        EXECUTE format('UPDATE %s SET %s = (SELECT rvalue FROM crossTabRvalue WHERE %s.t_rec = crossTabRvalue.t_rec AND %s.noaa_ar = ''%s'')'
                        , tabela, nomeaux, tabela, tabela, temp[i]
                      );

    END LOOP;

END;
$Q$ LANGUAGE plpgsql;