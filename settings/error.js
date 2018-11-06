const Sentry = require('@sentry/node');

Sentry.init({ dsn: 'https://fe871fe822de43a8a5dd0ba326c6e813@sentry.io/1317083' });

global.sentry = Sentry;