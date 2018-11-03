module.exports = (app) => {
    let cliente = require('../../core/cliente/clienteController');

    app.route('/cliente').get(cliente.selecionar);
    app.route('/cliente/:id').get(cliente.selecionarPorId);
    app.route('/cliente').post(cliente.inserir);
    app.route('/cliente/:id').put(cliente.atualizar);
    app.route('/cliente/:id').delete(cliente.excluir);
};