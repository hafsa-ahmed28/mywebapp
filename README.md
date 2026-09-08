# MyWebApp 
A hands-on exercise in connecting every layer of a real system: backend, frontend, database, and server infrastructure, into one working whole. Built with Django REST Framework, Flutter, NGINX, and MariaDB, featuring email-verified signup and secure login.

## What it does
Users sign up with an email, receive a verification link, confirm their account, and log in.

## Tech Stack
- Debian 12 on VirtualBox
- MariaDB 10.11 
- NGINX reverse proxy with self-signed TLS certificate (HTTPS on port 443)
- Python 3.11, Django 5.2, Django REST Framework
- Flutter web frontend
- Gmail SMTP for real email delivery

## API Endpoints
| Method | Endpoint | Description |
|--------|----------|--------------|
| POST | `/api/signup/` | Create account, send verification email |
| GET | `/api/verify/` | Verify email via token link |
| POST | `/api/login/` | Authenticate and return user ID |

## Security Notes
- All secrets stored as environment variables on the VM, nothing hardcoded in the repo
- Passwords hashed before saving to the database
- Verification token cleared after use
- CORS open for development, would be locked down in production

## To Run
**On the VM:**
```bash
cd /home/myproject
source venv/bin/activate
python manage.py runserver 0.0.0.0:8000
```

**On Windows:**
```bash
cd frontend
flutter run -d chrome --web-browser-flag "--ignore-certificate-errors"
```

## Why I Built This
Built as preparation for a software engineering internship, to learn the exact stack I'd be working with, as well as to sharpen my full-stack skills after trying full-stack development for the first time just days earlier at the 24-hour GDG hackathon.