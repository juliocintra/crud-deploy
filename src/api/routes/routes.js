module.exports = (app) => {
    app.get('/ping', (req, res) => {
        return res.status(200).json({message: 'OK!', data: new Date()});
    });
};