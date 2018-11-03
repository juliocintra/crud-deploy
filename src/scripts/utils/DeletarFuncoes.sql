/**/
CREATE OR REPLACE FUNCTION public.DeletarFuncoes(schemaFuncao TEXT, nomeFuncao TEXT)

    RETURNS TEXT AS $BODY$

/*
Documentação
Arquivo Fonte.....: DeletarFuncoes.sql
Objetivo..........: Identifica todas as funções com um schema e nome específico e as deleta.
Autor.............: Ítalo Andrade
Data..............: 16/09/2016
Ex................: SELECT public.DeletarFuncoes('Seguranca', 'DeletarFuncoes');
*/

DECLARE funcrow       RECORD;
        numfunctions  SMALLINT := 0;
        numparameters INT;
        i             INT;
        paramtext     TEXT;
BEGIN
    schemaFuncao := lower(schemaFuncao);
    nomeFuncao := lower(nomeFuncao);
    FOR funcrow IN SELECT proargtypes
                   FROM pg_proc
                   WHERE proname = nomeFuncao LOOP

        numparameters = array_upper(funcrow.proargtypes, 1) + 1;

        i = 0;
        paramtext = '';

        LOOP
            IF i < numparameters
            THEN
                IF i > 0
                THEN
                    paramtext = paramtext || ', ';
                END IF;
                paramtext = paramtext || (SELECT typname
                                          FROM pg_type
                                          WHERE oid = funcrow.proargtypes [i]);
                i = i + 1;
            ELSE
                EXIT;
            END IF;
        END LOOP;

        EXECUTE 'DROP FUNCTION ' || schemaFuncao || '.' || nomeFuncao || '(' || paramtext || ');';
        numfunctions = numfunctions + 1;

    END LOOP;

    RETURN '0';
END;
$BODY$
LANGUAGE plpgsql;


/**/