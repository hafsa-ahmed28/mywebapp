from django.urls import path
from .views import signup, verify_email, login

urlpatterns = [
	path('signup/', signup, name='signup'),
	path('verify/', verify_email, name='verify_email'),
	path('login/', login, name='login'),
]
