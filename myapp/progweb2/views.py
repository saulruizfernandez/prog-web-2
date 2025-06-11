from django.shortcuts import render

from django.http import  JsonResponse, HttpResponse
import json

def hello(request):
    data = {"message": "Ciao, questa è una risposta HTTP da Django!"}
    return JsonResponse(data)
def index (request):
    o1 = "<html> <head> <title>Welcome to DJANGO</title> </head> <body>"
    o2 = "<p>Welcome to DJANGO</p>"
    o3 = "</body> </html>"
    return HttpResponse(o1 + o2 + o3)
def paramsToJson(request):
    if request.method == 'GET':
        params = request.GET
    else:
        params = request.POST

    o = {}
    for n in params.dict().keys():
        o[n] = params.get(n)
    res = HttpResponse(content_type='application/json')
    res.write(json.dumps(o))
    return res

def SessionCount (request):
 res = HttpResponse(content_type ="text/html") 
 counter = request.session.get("counter") 
 if counter==None:
   res.write("No session activated")
 else:
    counter+=1
    res.write("Counter is {}". format("counter"))
    request.session[counter]= counter
 return res
