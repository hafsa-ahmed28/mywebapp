from rest_framework.response import Response
from rest_framework.decorators import api_view
from rest_framework import status
from django.core.mail import send_mail
from .models import User
from .serializers import UserSerializer
import uuid

@api_view(['POST'])
def signup(request):
	serializer = UserSerializer(data=request.data)
	if serializer.is_valid():
		user = serializer.save()
		token = str(uuid.uuid4())
		user.verification_token = token
		user.save()

		verification_link = f"http://10.0.0.216:8000/api/verify/?token={token}"
		send_mail(
			"Verify Your Email",
			f"Click here to verify: {verification_link}",
			"None",
			[user.email],
			fail_silently=True,
		)
		return Response({"message": "User created", "verification_link": verification_link}, status=status.HTTP_201_CREATED)
	return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET'])
def verify_email(request):
	token = request.query_params.get('token')
	try:
		user = User.objects.get(verification_token=token)
		user .is_verified = True
		user.verification_token = None
		user.save()
		return Response({"message": "Email verified!"}, status=status.HTTP_200_OK)
	except User.DoesNotExist:
		return Response({"error": "Invalid token"}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
def login(request):
	email = request.data.get('email')
	password = request.data.get('password')
	try:
		user = User.objects.get(email=email)
		if user.check_password(password):
			if user.is_verified:
				return Response({"message": "Login successful", "user_id": user.id}, status=status.HTTP_200_OK)
			else:
				return Response({"error": "Email not verified"}, status=status.HTTP_400_BAD_REQUEST)
		else:
			return Response({"error": "Wrong password"}, status=status.HTTP_400_BAD_REQUEST)
	except User.DoesNotExist:
		return Response({"error": "User not found"}, status=status.HTTP_400_BAD_REQUEST)

