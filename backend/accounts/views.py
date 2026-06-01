from rest_framework.response import Response #sends data back to Flutter
from rest_framework.decorators import api_view #turns a function into an API endpoint
from rest_framework import status #readable HTTP status codes (200, 201, 400)
from django.core.mail import send_mail #Django's built-in email sender
from django.conf import settings #access to settings.py values
from .models import User #my custom User model
from .serializers import UserSerializer #validates data and creates users
import uuid #generates unique random tokens


# SIGNUP
@api_view(['POST']) # POST only requests
def signup(request):
    serializer = UserSerializer(data=request.data) #pass incoming data to serializer for validation
    if serializer.is_valid():
        user = serializer.save() #creates user in DB with hashed password
        token = str(uuid.uuid4()) #generate unique verification token
        user.verification_token = token
        user.save()

        verification_link = f"http://10.0.0.216:8000/api/verify/?token={token}" # link sent in email

        send_mail(
            "Verify Your Email",
            f"Click here to verify: {verification_link}",
            settings.DEFAULT_FROM_EMAIL, #sender email from settings.py
            [user.email], #the user who just signed up
            fail_silently=True, #if email fails, don't crash, user is already saved
        )

        return Response({"message": "User created", "verification_link": verification_link}, status=status.HTTP_201_CREATED) # 201 = created

    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST) #400 = validation failed


# EMAIL VERIFICATION
@api_view(['GET']) #GET only 
def verify_email(request):
    token = request.query_params.get('token') #reads token from URL 
    try:
        user = User.objects.get(verification_token=token) #find user by token
        user.is_verified = True #mark as verified
        user.verification_token = None #clear token so it can't be reused
        user.save()
        return Response({"message": "Email verified!"}, status=status.HTTP_200_OK)
    except User.DoesNotExist:
        return Response({"error": "Invalid token"}, status=status.HTTP_400_BAD_REQUEST) #token not found


# LOGIN
@api_view(['POST'])
def login(request):
    email = request.data.get('email') #pull email from incoming request
    password = request.data.get('password') #pull password from incoming request
    try:
        user = User.objects.get(email=email) #find user by email
        if user.check_password(password): #hashes typed password and compares to stored hash
            if user.is_verified:
                return Response({"message": "Login successful", "user_id": user.id}, status=status.HTTP_200_OK)
            else:
                return Response({"error": "Email not verified"}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"error": "Wrong password"}, status=status.HTTP_400_BAD_REQUEST)
    except User.DoesNotExist:
        return Response({"error": "User not found"}, status=status.HTTP_400_BAD_REQUEST)
