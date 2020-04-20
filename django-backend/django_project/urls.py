"""django_project URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/1.11/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  url(r'^$', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  url(r'^$', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.conf.urls import url, include
    2. Add a URL to urlpatterns:  url(r'^blog/', include('blog.urls'))
"""
from django.conf.urls import url
from django.contrib import admin
from chatter import views
urlpatterns = [
 url(r'^getchatts/$', views.getchatts, name='getchatts'),
 url(r'^addchatt/$', views.addchatt, name='addchatt'),
 url(r'^adduser/$', views.adduser, name='adduser'),
 url(r'^logon/$', views.logon, name='logon'),
 url(r'^call/$', views.call, name='call'),
 url(r'^addloc/$', views.addloc, name='addloc'),
 url(r'^getloc/$', views.getloc, name='getloc'),
]
