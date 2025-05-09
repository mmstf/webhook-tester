import express, {query} from 'express';
import jwt from 'jsonwebtoken';

const app = express();
const port = process.env.PORT || 15777;
const jwtSecret = process.env.JWT_SECRET || "string";

app.use(express.json());

const processWebhook = async (req, res) => {
    let response;
    try {
        let authToken;
        let decodedTokenPayload;
        
        if (
            req.headers.authorization 
                && (req.headers.authorization.split(' ')[0] === "Bearer")
        ) {
            authToken = req.headers.authorization ? req.headers.authorization.split(' ')[1] : undefined;
        }

        if (authToken) {
            decodedTokenPayload = jwt.verify(authToken, jwtSecret)
        }

        const endpoint = req.url
        const httpMethod = req.method || 'ALL';
        const query = req.query;
        const body = req.body;
        response = {endpoint, httpMethod, authToken, query, body, decodedTokenPayload}

        console.log("[INFO] Webhook Data", JSON.stringify(response, null, 2));
        res.json(response)
    } catch (e) {
        console.error("[ERROR] Processing Webhook:", e.name, e.message);

        response = {errorName: e.name, errorMessage: e.message}
        res.status(500).json(response);
    }
}


app.all('*', processWebhook)

app.listen(port, () => console.log(`Webhook Tester Util is Listening on port ${port}`));