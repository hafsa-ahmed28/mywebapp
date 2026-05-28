from rest_framework import serializers #DRF tool for converting JSON <-> Python objects
from .models import User #my custom User model

class UserSerializer(serializers.ModelSerializer): #auto-knows the User model's fields
    class Meta:
        model = User #which model this serializer works with
        fields = ['id', 'email', 'username', 'password', 'is_verified'] #only these fields are processed
        extra_kwargs = {
            'password': {'write_only': True} #password can come in but never goes back out in a response
        }

    def create(self, validated_data): #runs when serializer.save() is called in signup
        password = validated_data.pop('password') #pull password out separately so it gets hashed properly
        user = User.objects.create_user(**validated_data, password=password) #create_user hashes the password automatically
        return user