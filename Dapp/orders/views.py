from django.shortcuts import render

# Create your views here.
def welcome(request):
	return render(request, 'orders/welcome.html')

def dashboard(request):
	return render(request, 'orders/dashboard.html')