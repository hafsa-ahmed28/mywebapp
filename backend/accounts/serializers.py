from rest_framework import serializers
from .models import User

class UserSerializer(serializers.ModelSerializer):
	class Meta:
		model = User
		fields = ['id', 'email', 'username', 'password', 'is_verified']
		extra_kwargs = {
			'password': { 'write_only': True}
		}

	def create(self, validated_data):
		password = validated_data.pop('password')
		user = User.objects.create_user(**validated_data, password=password)
		return user
