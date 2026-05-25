# mywebapp Auth — Full-Stack Sign-Up / Sign-In App

A full-stack authentication application. Demonstrates end-to-end user signup with email verification, login, and secure HTTPS communication between a Flutter frontend and a Django REST backend, with data persisted in MariaDB.

---

## Tech Stack

| Layer | Technology |
|---|---|
| OS (server) | Debian 12 |
| Web server / reverse proxy | NGINX |
| Backend language | Python 3.11 |
| Backend framework | Django 5.2 + Django REST Framework |
| Database | MariaDB 10.11 (MySQL-compatible) |
| Frontend | Flutter (web target) |
| Transport security | HTTPS via self-signed TLS certificate |
| Email delivery | SMTP through Gmail |

---

## Architecture

Flutter (Chrome)
│   HTTPS (port 443, TLS)
▼
NGINX (reverse proxy, SSL termination)
│   HTTP (port 8000, internal)
▼
Django + DRF (REST API)
│
├──► MariaDB (user storage)
└──► Gmail SMTP (verification email)

NGINX terminates TLS on port 443 and forwards requests to Django on port 8000. Django itself never handles TLS — that's a separation of concerns standard in production deployments.

---

## Features

- **Sign-up** with email, username, and password (password hashed via Django's `make_password`)
- **Email verification** — generates a unique UUID token, emails a clickable verification link, and marks the user as verified when the link is hit
- **Sign-in** — credentials checked against the database; rejects unverified users
- **HTTPS** — all client–server traffic is encrypted
- **CORS** configured so the Flutter client can communicate with the API
- **Validation errors** returned from the API in human-readable JSON

---

## API Endpoints

| Method | Endpoint | Purpose | Success | Failure |
|---|---|---|---|---|
| POST | `/api/signup/` | Create new user, send verification email | 201 + `verification_link` | 400 + field errors |
| GET | `/api/verify/?token=...` | Mark user as verified | 200 + message | 400 + invalid token |
| POST | `/api/login/` | Authenticate verified user | 200 + `user_id` | 400 + error message |

Example signup request body:
```json
{
  "email": "user@example.com",
  "username": "newuser",
  "password": "securepassword123"
}
```

---

## Project Structure

trispects-app/
├── backend/                # Django REST API
│   ├── accounts/           # User app: models, views, serializers, URLs
│   ├── config/             # Django project settings & URL routing
│   ├── manage.py
│   └── requirements.txt
└── frontend/               # Flutter web app
├── lib/
│   ├── main.dart           # App entry point & routing
│   ├── api_service.dart    # HTTP client for backend
│   ├── signup_screen.dart
│   └── login_screen.dart
└── pubspec.yaml

---

## Setup Instructions

### 1. Backend (Debian VM)

```bash
# System dependencies
sudo apt update
sudo apt install python3 python3-venv python3-pip mariadb-server nginx -y

# Database
sudo mariadb -u root -e "CREATE DATABASE django_db CHARACTER SET utf8mb4;"

# Project
cd backend
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Environment variables (replace with your own values)
export DJANGO_SECRET_KEY='your-django-secret-key'
export EMAIL_HOST_USER='your.gmail@gmail.com'
export EMAIL_HOST_PASSWORD='your-16-char-app-password'
export DEFAULT_FROM_EMAIL='your.gmail@gmail.com'

# Migrations & run
python manage.py migrate
python manage.py runserver 0.0.0.0:8000
```

### 2. NGINX (HTTPS reverse proxy)

Generate a self-signed certificate:

```bash
sudo mkdir -p /etc/nginx/ssl
cd /etc/nginx/ssl
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout selfsigned.key -out selfsigned.crt
```

Set the Common Name to your server's IP.

Configure `/etc/nginx/sites-available/default` to listen on 443 with SSL and proxy to `127.0.0.1:8000`. Reload NGINX:

```bash
sudo nginx -t
sudo systemctl reload nginx
```

### 3. Frontend (Flutter)

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

The first time you load the app, Chrome will warn that the self-signed certificate isn't trusted. Visit `https://<server-ip>/api/signup/` directly once and click through the warning so subsequent API calls succeed.

---

## Production Notes / Known Limitations
- **TLS certificate** — currently self-signed, which triggers a browser warning. Production would use Let's Encrypt or a commercial CA.
- **Server IP hardcoded** — Flutter's `api_service.dart` and NGINX config reference a specific IP. Production would use a real domain name with DNS.
- **Secrets** — `SECRET_KEY` and email credentials are read from environment variables but not currently loaded from a `.env` file or secrets manager.
- **Email provider** — Gmail SMTP works but isn't ideal for deliverability at scale. A transactional email service like SendGrid or AWS SES would be used in production.
- **CORS** — currently set to `CORS_ALLOW_ALL_ORIGINS = True` for prototype simplicity. Production would whitelist specific origins.
- **Django dev server** — `manage.py runserver` is used for development. Production would run Django behind Gunicorn or uWSGI.
- **Login session** — login currently returns the user ID. A production system would issue a JWT or session token.

