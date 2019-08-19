let app = require('express')();
let bodyParser = require('body-parser');
let consign = require('consign')({verbose: false});
const nodemailer = require("nodemailer");
// const handlebars = require('handlebars');
const fs = require('fs');

require('./settings/db');
require('./settings/error');

app.use(bodyParser.json({limit: '30mb'}));
app.use(bodyParser.urlencoded({limit: '30mb', extended: true}));

app.use(require('./src/api/middleware/cors'));
app.use(require('./src/api/middleware/response'));

// const fs = require('fs');
// const templatePath = './template.handlebars';
// const template = handlebars.compile(fs.readFileSync(templatePath).toString('utf-8'));
// const html = template({
//
// });

let source = fs.readFileSync('./template.handlebars', 'utf8');
// Create email generator
// let template = handlebars.compile(source);

let transporter = nodemailer.createTransport({
    host: 'smtp-mail.outlook.com',
    port: 587,
    secure: false, // true for 465, false for other ports
    auth: {
        user: 'julinn_cesar@hotmail.com', // generated ethereal user
        pass: 'julio1010' // generated ethereal password
    }
});

app.get('/teste', async (req, res) => {
    try {
        await transporter.sendMail({
            from: 'julinn_cesar@hotmail.com', // sender address
            to: 'julinn_cintra@hotmail.com', // list of receivers
            subject: 'Hello ✔', // Subject line
            text: 'Hello world?', // plain text body,
            html: source
        });
        return res.json({ teste: 'E-mail enviado com sucesso' });
    } catch (e) {
        return res.json(e);
    }
});

consign
    .include('./src/api/routes')
    .into(app);

app.listen(3000, () => {
    console.log('Servidor rodando na porta 3000');
});
