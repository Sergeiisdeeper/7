from django.urls import path
from . import views

urlpatterns = [
    path('', views.login_view, name='login'),  # Route for the login page
]

