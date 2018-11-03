SELECT public.DeletarFuncoes('Administracao', 'SelecionarCliente');
CREATE OR REPLACE FUNCTION Administracao.SelecionarCliente()
    RETURNS TABLE(
        "id"        INTEGER,
        "nome"      VARCHAR(200),
        "endereco"  VARCHAR(200),
        "cpf"       BIGINT
    ) AS $$

/*

SELECT * FROM Administracao.SelecionarCliente();

*/

BEGIN

    RETURN QUERY
    SELECT
        c.id,
        c.nome,
        c.endereco,
        c.cpf
    FROM Administracao.Cliente c;
END;

$$
LANGUAGE PLPGSQL;

/**/

SELECT public.DeletarFuncoes('Administracao', 'SelecionarClientePorId');
CREATE OR REPLACE FUNCTION Administracao.SelecionarClientePorId(
    pId INTEGER
)
    RETURNS TABLE(
        "id"        INTEGER,
        "nome"      VARCHAR(200),
        "endereco"  VARCHAR(200),
        "cpf"       BIGINT,
        "telefones" JSON
    ) AS $$

/*

SELECT * FROM Administracao.SelecionarClientePorId(1);

*/

BEGIN

    RETURN QUERY
    SELECT
           c.id,
           c.nome,
           c.endereco,
           c.cpf,
           (
           SELECT COALESCE(json_agg(tel), '[]')
           FROM
                (
                SELECT
                       ct.id,
                       ct.numero
                FROM Administracao.clienteTelefone ct
                WHERE ct.idCliente = c.id
                ) tel
           ) telefone
    FROM Administracao.Cliente c
    WHERE c.id = pId;
END;

$$
LANGUAGE PLPGSQL;

/**/

SELECT public.DeletarFuncoes('Administracao', 'InserirCliente');
CREATE OR REPLACE FUNCTION Administracao.InserirCliente(
    pNome       VARCHAR(200),
    pEndereco   VARCHAR(200),
    pCpf        BIGINT,
    pTelefones  JSON

)
    RETURNS JSON AS $$

/*

SELECT * FROM Administracao.InserirCliente(
    'Aberto',
    'Rua Getulio Vargas',
    44455566611,
    '[{"numero": "(16) 99521-9985"}, {"numero": "(16) 98221-1225"}]' :: JSON
);

*/

DECLARE
    vReturningId    INTEGER;

BEGIN

    INSERT INTO Administracao.Cliente(
        nome,
        endereco,
        cpf
    ) VALUES (
        pNome,
        pEndereco,
        pCpf
    ) RETURNING id
        INTO vReturningId;

    INSERT INTO Administracao.ClienteTelefone(
        idCliente,
        numero
    ) SELECT
        vReturningId,
        tel.numero
    FROM
         (
             SELECT x."numero" AS numero
             FROM json_to_recordset(pTelefones)
             AS x(
                 "numero"   VARCHAR
                 )
         ) tel;

    RETURN
    json_build_object(
        'executionCode', 0,
        'message', 'Cliente cadastrado com sucesso'
    );
END;

$$
LANGUAGE PLPGSQL;

/**/

SELECT public.DeletarFuncoes('Administracao', 'AtualizarCliente');
CREATE OR REPLACE FUNCTION Administracao.AtualizarCliente(
    pId         INTEGER,
    pNome       VARCHAR(200),
    pEndereco   VARCHAR(200),
    pCpf        BIGINT,
    pTelefones  JSON

)
    RETURNS JSON AS $$

/*

SELECT * FROM Administracao.AtualizarCliente(
    5,
    'Aberto',
    'Rua Getulio Vargas',
    44455566611,
    '[{"numero": "(16) 99521-9985"}, {"numero": "(16) 98221-1225"}]' :: JSON
);

*/

BEGIN
    IF NOT EXISTS(SELECT 1
                FROM Administracao.Cliente c
                WHERE c.id = pId)
    THEN RETURN
    json_build_object(
        'executionCode', 1,
        'message', 'Cliente não cadastrado'
    );
    END IF;

    UPDATE Administracao.Cliente
    SET nome     = pNome,
        endereco = pEndereco,
        cpf      = pCpf
    WHERE id = pId;

    DELETE FROM Administracao.ClienteTelefone
    WHERE idCliente = pId;

    INSERT INTO Administracao.ClienteTelefone(
        idCliente,
        numero
        ) SELECT
                 pId,
                 tel.numero
    FROM
         (
         SELECT x."numero" AS numero
         FROM json_to_recordset(pTelefones)
                  AS x(
                      "numero"   VARCHAR
                  )
         ) tel;

    RETURN
    json_build_object(
        'executionCode', 0,
        'message', 'Cliente atualizado com sucesso'
    );
END;
$$
LANGUAGE PLPGSQL;

/**/

SELECT public.DeletarFuncoes('Administracao', 'ExcluirCliente');
CREATE OR REPLACE FUNCTION Administracao.ExcluirCliente(
    pId         INTEGER

)
    RETURNS JSON AS $$

/*

SELECT * FROM Administracao.ExcluirCliente(6);

*/

BEGIN
    IF NOT EXISTS(SELECT 1
                  FROM Administracao.Cliente c
                  WHERE c.id = pId)
    THEN RETURN
    json_build_object(
        'executionCode', 1,
        'message', 'Cliente não cadastrado'
    );
    END IF;

    DELETE FROM Administracao.ClienteTelefone
    WHERE idCliente = pId;

    DELETE FROM Administracao.Cliente
    WHERE id = pId;

    RETURN
    json_build_object(
        'executionCode', 0,
        'message', 'Cliente excluido com sucesso'
    );
END;
$$
LANGUAGE PLPGSQL;
