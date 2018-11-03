const databaseConfig = {
    'host': 'localhost',
    'port': 5432,
    'database': 'deploy',
    'user': 'postgres',
    'password': '1234',
    'ssl': false
    // 'sslfactory': 'org.postgresql.ssl.NonValidatingFactory'
};

const db = require('pg-promise')()(databaseConfig);

global.db = {
    json: async function (query, params) {
        let result = await db.proc(query, params);

        return result ? result[Object.keys(result)[0]] : null;
    },
    query: db.query,
    proc: db.proc,
    func: db.func
};