const db = global.db;

module.exports = {
    selecionar,
    selecionarPorId,
    inserir,
    atualizar,
    excluir
};

async function selecionar() {

    // throw {
    //     httpCode: 409,
    //     message: 'Dados informados inválidos'
    // }

    throw {
        httpCode: 500,
        message: 'Erro interno 2'
    }
    // return db.func('Administracao.SelecionarCliente');
}

async function selecionarPorId(params) {
    return db.func('Administracao.SelecionarClientePorId', [
        params.id
    ]);
}

async function inserir(params) {
    return await db.json('Administracao.InserirCliente', [
        params.nome,
        params.endereco,
        params.cpf,
        params.telefone
    ]);
}

async function atualizar(params) {
    let data = await db.json('Administracao.AtualizarCliente', [
        params.id,
        params.nome,
        params.endereco,
        params.cpf,
        params.telefone
    ]);

    let error;

    switch (data.executionCode) {
        case 1:
            error = data;
            error.httpCode = 409
    }

    if (error) throw error;

    return data;
}

async function excluir(params) {
    let data = await db.json('Administracao.ExcluirCliente', [
        params.id
    ]);

    let error;

    switch (data.executionCode) {
        case 1:
            error = data;
            error.httpCode = 409
    }

    if (error) throw error;

    return data;
}