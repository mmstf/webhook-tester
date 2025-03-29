# 📡 Webhook Tester Util

**Webhook Tester Util** helps you test incoming requests from external applications and correctly integrate them. It starts a simple web server using **Node.js (Express.js)** and listens on **port 15777 by default**. The server captures all types of requests and returns useful debugging information such as URL, params, query, token, and body.  

It can be useful for applications with event-based reporting, like jitsi-meet, zoom (room-created, user-joined, etc.) and etc.

---

## 🚀 Installation

You can install and run Webhook Tester Util using one of the following methods:
### 0. Prerequisites

**Docker** must be installed if you use option 1 and 2 (Recommended)  
**Node.js** must be installed if you use option 3


### 1. Quick Install (Bash script)

```bash
wget -O init.sh https://raw.githubusercontent.com/mmstf/webhook-tester/refs/heads/master/init.sh
chmod +x init.sh
sudo ./init.sh
```

This [script](https://raw.githubusercontent.com/mmstf/webhook-tester/refs/heads/master/init.sh) downloads app image, setups nginx configuration and starts the Webhook Tester automatically.

### 2. Manual Installation (Docker)

If you prefer manual setup, you can use Docker:

```bash
docker pull mmstf/webhook-tester:v1.0.0

docker run -itd mmstf/webhook-tester:v1.0.0 --rm --name webhook-tester-util -p 15777:15777
```

### 3. Manual Installation (Source Code)

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

| Variable       | Default                 | Description                                    |
| -------------- | ----------------------- |------------------------------------------------|
| `PORT`         | `15777`                 | Port to listen on                              |
| `JWT_SECRET`   | `string`                | JWT token secret, if Bearer token is specified |

For Docker, set environment variables like this:

```bash
docker run -d --name webhook-tester-util -p 8080:8080 -e PORT=8080 -e JWT_SECRET=another-string mmstf/webhook-tester:v1.0.0
```

For manual setup, export envs:

```ini
export PORT=8080
export JWT_SECRET=string
```

And start the server:

```bash
npm start
```

---

## 📌 Usage

### 🔥 Testing Webhooks

Once the server is running, you can send requests manually to `http://your-webhook-domain` or specify you webhook-domain to your application:

```bash
curl -X POST http://localhost:15777/webhook \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello, Webhook!"}'
```

You can check logs 
```bash
docker logs webhook-tester-util
```

**Example Response:**

```string
[INFO] Webhook Data {
  "endpoint": "/webhook",
  "httpMethod": "POST",
  "query": {},
  "body": {
    "message": "Hello, Webhook!"
  }
}
```

### 🔄 Setting Up Nginx Proxy Manually (Optional)

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
