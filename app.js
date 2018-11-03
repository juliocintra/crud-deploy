let app = require('express')();
let bodyParser = require('body-parser');
let consign = require('consign')({verbose: false});
require('./settings/db');

app.use(bodyParser.json({limit: '30mb'}));
app.use(bodyParser.urlencoded({limit: '30mb', extended: true}));

app.use(require('./src/api/middleware/cors'));
app.use(require('./src/api/middleware/response'));

consign
    .include('./src/api/routes')
    .into(app);

app.listen(3000, () => {
    console.log('Servidor rodando na porta 3000');
});
