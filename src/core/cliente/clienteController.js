const repository = require('./clienteRepository');

module.exports = {
    selecionar,
    selecionarPorId,
    inserir,
    atualizar,
    excluir
};

async function selecionar(req, res) {
    let data = await repository.selecionar();

    return res.finish({content: data});
}

async function selecionarPorId(req, res) {
    let params = {
        id: req.params.id
    };

    let data = await repository.selecionarPorId(params);

    return res.finish({content: data[0]});
}

async function inserir(req, res) {
    let params = {
        nome: req.body.nome,
        endereco: req.body.endereco,
        cpf: req.body.cpf,
        telefone: req.body.telefone ? JSON.stringify(req.body.telefone) : null
    };

    try {

        let data = await repository.inserir(params);

        return res.finish(data);
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function atualizar(req, res) {
    let params = {
        id: req.params.id,
        nome: req.body.nome,
        endereco: req.body.endereco,
        cpf: req.body.cpf,
        telefone: req.body.telefone ? JSON.stringify(req.body.telefone) : null
    };

    try {
        let data = await repository.atualizar(params);

        return res.finish(data);
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}

async function excluir(req, res) {
    let params = {
        id: req.params.id
    };

    try {
        let data = await repository.excluir(params);

        return res.finish(data);
    } catch (error) {
        return res.finish({
            httpCode: error.httpCode || 500,
            error
        });
    }
}