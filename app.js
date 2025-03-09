import express from 'express';
import jwt from 'jsonwebtoken';

const app = express();
const port = process.env.PORT || 3001;

app.use(express.json());

app.get('*', async (req, res) => {
    try {
        let authToken = req.headers.authorization ? req.headers.authorization.split(' ')[1] : undefined;
        const endpoint = req.url
        const httpMethod = req.method || 'GET';
        const query = req.query;

        res.json({endpoint, httpMethod, authToken, query})
    } catch (e) {
        res.json({error: e})
    }
})

app.post('*', async (req, res) => {
    try {
        let authToken = req.headers.authorization ? req.headers.authorization.split(' ')[1] : undefined;
        const endpoint = req.url
        const httpMethod = req.method || 'POST';
        const query = req.query;
        const body = req.body;

        res.json({endpoint, httpMethod, authToken, query, body})
    } catch (e) {
        res.json({error: e});
    }
})

app.listen(port, () => console.log(`Listening on port ${port}`));