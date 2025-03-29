# 📡 Webhook Tester Util

**Webhook Tester Util** helps you test incoming requests from external applications and correctly integrate them. It starts a simple web server using **Node.js (Express.js)** and listens on **port 15777 by default**. The server captures all types of requests and returns useful debugging information such as URL, params, query, token, and body.

---

## 🚀 Installation

You can install and run Webhook Tester Util using one of the following methods:

### 1️⃣ Quick Install (Recommended)

```bash
curl -sSL https://github.com/mmstf/webhook-tester/refs/heads/master/init.sh | bash
```

This script downloads and starts the Webhook Tester automatically.

### 2️⃣ Manual Installation (Docker)

If you prefer manual setup, you can use Docker:

```bash
docker pull mmstf/webhook-tester:v1.0.0

docker run -itd mmstf/webhook-tester:v1.0.0 --rm --name webhook-tester-util -p 15777:15777
```

### 3️⃣ Manual Installation (Source Code)

If you need to modify the code, clone the repository and run it manually:

```bash
git clone https://github.com/mmstf/webhook-tester.git
cd webhook-tester
npm install
npm start
```

---

## ⚙️ Configuration

Webhook Tester Util supports configuration via **environment variables**:

| Variable       | Default                 | Description                             |
| -------------- | ----------------------- | --------------------------------------- |
| `PORT`         | `15777`                 | Port to listen on                       |
| `JWT_SECRET`   | `string`                | JWT token decoder for incoming requests |
| `NGINX_CONFIG` | `proxy_pass port:15777` | Path to custom Nginx configuration      |

For Docker, set environment variables like this:

```bash
docker run -d -p 8080:15777 -e PORT=8080 mmstf/webhook-tester:v1.0.0
```

For manual setup, create a **.env** file:

```ini
PORT=8080
JWT_SECRET=debug
```

And start the server:

```bash
npm start
```

---

## 📌 Usage

### 🔥 Testing Webhooks

Once the server is running, send requests to `http://your-server-ip:15777`:

```bash
curl -X POST http://localhost:15777/webhook \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello, Webhook!"}'
```

**Example Response:**

```json
Webhook data {
  "endpoint": "/request-endpoint",
  "httpMethod": "POST",
  "authToken": "eyJhbGciOiJIUzI1NiIsIXVCJ9.eSI6IkpvaGRtydWUsImlhdCI6MTUxNjIzOTAyMn0.KMUFsIDTn9FNFUqJp-QV30",
  "query": {...},
  "body": {...},
  "decodedTokenPayload": {...}
}
```

### 🔄 Setting Up Nginx Proxy (Optional)

If you need to proxy requests through **Nginx**, use this configuration:

```nginx
server {
    listen 80;
    server_name webhook.example.com;

    location / {
        proxy_pass http://localhost:15777;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    }
}
```

After updating the config, restart Nginx:

```bash
sudo systemctl restart nginx
```

---

## 🔧 Troubleshooting

- **Port already in use?**

  ```bash
  lsof -i :15777   # Check what process is using the port
  kill -9 <PID>     # Kill the process
  ```

  Or change the `PORT` variable.

- **Docker container not running?**

  ```bash
  docker ps -a   # Check container status
  docker logs webhook-tester  # View logs
  ```

- **Permission denied?**
  ```bash
  chmod +x init.sh  # If using init script
  ```

---

## 🎯 Conclusion

Webhook Tester Util is a lightweight, easy-to-use tool for debugging webhooks. Whether you run it via **Docker**, **Nginx proxy**, or **source code**, it provides a simple way to capture and inspect webhook requests.

✅ Happy debugging!
