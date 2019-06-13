from django.db import models
from django.contrib.auth.models import User
import datetime

# Create your models here.
class Cert(models.Model):
	token = models.CharField(max_length=256)
	user = models.ForeignKey(User, on_delete=models.CASCADE)
	title = models.CharField(max_length=256)
	location = models.CharField(max_length=256)
	org = models.CharField(max_length=256)
	is_verified = models.BooleanField(default=False)
	time_till = models.DateTimeField()

	def __str__(self):
	    return f'{self.user.username} Profile'

