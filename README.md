## MyWebApp 
- A full-stack web application 

## What it does
- User registration with email verification and login. A user signs up, receives a verification email, clicks the link to confirm their account, and can then log in.

## Tech Stack
- Debian 12 on VirtualBox
- MariaDB 10.11 (MySQL-compatible drop-in replacement)
- NGINX reverse proxy with self-signed TLS certificate (HTTPS on port 443)
- Python 3.11, Django 5.2, Django REST Framework
- Flutter web frontend
- Gmail SMTP for real email delivery


## Project Structure
mywebapp/
├── backend/
│   ├── config/          # Project settings and main URL routing
│   └── accounts/        # User model, serializer, views, URLs
└── frontend/
    └── lib/
        ├── main.dart          # Entry point and home screen
        ├── api_service.dart   # Backend communication layer
        ├── signup_screen.dart # Signup form
        └── login_screen.dart  # Login form

## API Endpoints
- MethodEndpointDescriptionPOST/api/signup/Create account, send verification emailGET/api/verify/Verify email via token linkPOST/api/login/Authenticate and return user ID

## Security Notes
- All secrets stored as environment variables on the VM, nothing hardcoded in the repo
- Passwords hashed before saving to the database
- Verification token cleared after use
- CORS open for development, would be locked down in production

## To Run
--> On the VM:
    - cd /home/myproject
    - source venv/bin/activate
    - python manage.py runserver 0.0.0.0:8000

--> On Windows:
    - cd frontend
    - flutter run -d chrome --web-browser-flag "--ignore-certificate-errors"
