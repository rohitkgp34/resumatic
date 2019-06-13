from django.shortcuts import render, redirect, get_object_or_404
from django.contrib import messages
from django.contrib.auth.decorators import login_required
from .forms import UserUpdateForm, ProfileUpdateForm, UserRegisterForm
from django.views.generic import ListView, DetailView, CreateView, UpdateView, DeleteView
from .models import *
from django.contrib.auth.models import User
from django.contrib.admin.views.decorators import staff_member_required
from django.utils.decorators import method_decorator
# Create your views here.


def register(request):
    if request.method == "POST":
        form = UserRegisterForm(request.POST)
        if form.is_valid():
            form.save()
            username = form.cleaned_data.get('username')
            first_name = form.cleaned_data.get('first_name')
            last_name = form.cleaned_data.get('last_name')
            messages.success(request, f'Account has been created!')
            return redirect('register')
    else:
        form = UserRegisterForm()
    return render(request, 'users/register.html', {'form': form, 'name': 'Register User'})

@login_required
def profile(request):
    if request.method == 'POST':
        u_form = UserUpdateForm(request.POST, instance=request.user)
        p_form = ProfileUpdateForm(request.POST,
                                   request.FILES,
                                   instance=request.user.profile)
        if u_form.is_valid() and p_form.is_valid():
            u_form.save()
            p_form.save()
            messages.success(request, f'Your account has been updated!')
            return redirect('profile')

    else:
        u_form = UserUpdateForm(instance=request.user)
        p_form = ProfileUpdateForm(instance=request.user.profile)

    context = {
        'u_form': u_form,
        'p_form': p_form
    }

    return render(request, 'users/profile.html', context)


@login_required
def post_create(request):
    if request.method == "POST":
        form = AdForm(request.POST, request.FILES)
        if form.is_valid():
            form.instance.task_by = request.user
            form.save()
            return redirect('history')
    else:
        form = AdForm()
    return render(request, 'orders/ad_form.html', {'form': form})

class History(ListView):
    model = AdFile
    template_name = 'orders/history.html'
    context_object_name = 'ads'
    # ordering = ['-date_uploaded']
    # paginate_by = 5

    def get_queryset(self):
        return AdFile.objects.filter(task_by= self.request.user).order_by('-date_uploaded')


@method_decorator(staff_member_required, name='dispatch')
class OrderHistory(ListView):
    model = AdFile
    template_name = 'orders/orderhistory.html'
    context_object_name = 'ads'
    ordering = ['-date_uploaded']
    # paginate_by = 10
