from django.shortcuts import render, redirect
from django.contrib.auth.decorators import login_required
from django.contrib import messages
import subprocess
from kyc.models import *
from users.forms import *
import uuid
import json
import time
import requests
# Create your views here.
def welcome(request):
	certs = None

	if(request.user.is_authenticated):
		if request.user.profile.is_org:
			if request.method == "POST":
				cert = Cert.objects.filter(token = request.POST["token"])
				if request.POST['Decision']=="Confirm":
					cert.update(is_verified=True)
					cert = list(cert)[0]
					# Update in blockchain
					cmd = ['node', 'SDK/invoke.js', 'VerifyClaim', cert.token]
					out = subprocess.run(cmd ,encoding="utf-8", stdout=subprocess.PIPE)
					print(out.stdout)
					messages.success(request,"Accepted")
			certs = Cert.objects.filter(org = request.user.username)
		else:
			certs = Cert.objects.filter(user = request.user)
		
		## query tokens from blockchain
		L = exhaustiveQuery(certs)

		print(L)
	return render(request, 'kyc/index.html', {"certs": L})

@login_required
def webcam(request):
	return render(request, 'kyc/webcam.html')

@login_required
def terminal(request, key=0):
	states = [('KYC', '', 1),
			 ('Get aadhar number', '', 2),
			 ('Update KYC', '', 3),
			]
	me = subprocess.check_output("ls")
	if key != 0:
		if key==3:
			return redirect('webcam')
		if key==1:
			me = subprocess.check_output(['node', 'invoke.js'])
		if key==2:
			me = subprocess.check_output(['node', 'query.js'])
		messages.info(request, me.decode("utf-8"))
		
	context ={
		'names' : states
	}
	return render(request, 'kyc/terminal.html', context)

@login_required
def make_claim(request):
	if request.method == "POST":
		form = RegisterCertForm(request.POST)
		if form.is_valid():
			cert = form.save(commit=False)
			cert.user = request.user
			cert.token = str(uuid.uuid4())
			cert.save()
			#push it to blockchain
			#MakeClaim: hash, uid, OrgId, Skill, Duration
			out = subprocess.run(["node", "SDK/invoke.js", "MakeClaim", cert.token, cert.user.username, cert.org.replace(" ", "_"), cert.title.replace(" ", "_"), str(cert.time_till).replace(" ", "_")], encoding="utf-8", stdout=subprocess.PIPE)
			out = out.stdout
			messages.success(request, out)
			return redirect('welcome')
	else:
		form = RegisterCertForm()
	return render(request, 'users/register.html', {'form': form, 'name': 'Add Credentials'})

def exhaustiveQuery(certs):
	context = []
	# print("Hello=================================")
	for cert in certs:
		cmd = ['node', 'SDK/query.js', 'Query', cert.token]
		out = subprocess.run(cmd ,encoding="utf-8", stdout=subprocess.PIPE)
		out = out.stdout
		out = out[out.find("{"):]
		context.append( (cert.token, json.loads(out)) )
		
	return context
