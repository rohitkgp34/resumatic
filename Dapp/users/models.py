from django.db import models
from django.contrib.auth.models import User
import datetime

class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    dob  = models.DateField(default=datetime.date(2000,1,1))
    is_org = models.BooleanField(default=False)
    image = models.ImageField(default='default.png', upload_to='profile_pics')
    
    def __str__(self):
        return f'{self.user.username} Profile'

    def save(self, *args, **kwargs):
        super().save()

# Create your models here.
class AdFile(models.Model):
	document = models.FileField(upload_to='customer_files',blank=True)
	link = models.CharField(max_length=100, default='', blank=True)
	date_uploaded = models.DateTimeField(auto_now_add=True)
	text = models.CharField(max_length=1000, default='', blank=True)
	text_color = models.CharField(max_length=7, default='', blank=True)
	bg_color = models.CharField(max_length=7, default='', blank=True)
	task_by = models.ForeignKey(User, on_delete=models.CASCADE)
	

	def __str__(self):
		return str(self.date_uploaded)

