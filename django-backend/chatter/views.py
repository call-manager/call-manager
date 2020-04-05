# -*- coding: utf-8 -*-
from __future__ import unicode_literals
import time
from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
import json
from django.http import JsonResponse, HttpResponse
from django.db import connection
import threading

@csrf_exempt
def calltest(request):
 if request.method != 'POST':
     return HttpResponse(status=404)
 json_data = json.loads(request.body)
 user_name = json_data["user"]
 return JsonResponse({"user_name": user_name})



def getchatts(request):
 if request.method != 'GET':
    return HttpResponse(status=404)
 response = {}
 cursor = connection.cursor()
 variable = "false"
 cursor.execute('UPDATE USERS SET name = (%s)'% (variable))
 return JsonResponse({})


@csrf_exempt
def addchatt(request):
    if request.method != 'POST':
        return HttpResponse(status=404)
    json_data = json.loads(request.body)
    username = json_data['username']
    message = json_data['message']
    cursor = connection.cursor()
    cursor.execute('INSERT INTO chatts (username, message) VALUES '
        '(%s, %s);', (username, message))
    return JsonResponse({})


@csrf_exempt
def logon(request):
    
    json_data = json.loads(request.body)
    user_name = json_data["user"] 
    cursor = connection.cursor()
    cursor.execute('SELECT username, name from USERS')
    rows = cursor.fetchall()
    found = 0
    for each in rows:
        if each[0] == user_name:
            if each[1] == "true":
                return JsonResponse({"status": "calling"})
    if found == 0:
        cursor.execute('INSERT INTO USERS (username, name, email) VALUES (%s, %s, %s)', (user_name, "false", "email"))
    return JsonResponse({"status": "No call"})


@csrf_exempt
def call(request):
    if request.method != 'POST':
        return HttpResonpse(status=404)
    json_data = json.loads(request.body)
    user_name = json_data["user"]
    cursor = connection.cursor()
    cursor.execute('UPDATE USERS SET name = %s WHERE username = %s', ("true", user_name))    
    return JsonResponse({})



@csrf_exempt
def adduser(request):
 if request.method != 'POST':
    return HttpResponse(status=404)
 json_data = json.loads(request.body)
 username = json_data['username']
 name = json_data['name']
 email = json_data['email']
 cursor = connection.cursor()
 cursor.execute('INSERT INTO users (username, name, email) VALUES '
 '(%s, %s, %s);', (username, name, email))
 return JsonResponse({})
