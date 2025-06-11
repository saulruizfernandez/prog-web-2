from django.shortcuts import render
from .mongo_client import db

from django.http import  JsonResponse, HttpResponse
import json


def serverlocal(request):
    collezione = db["tab1"]  # Sostituisci con il nome della tua collezione
    dati = list(collezione.find({}))
    # Converti ObjectId in stringa per evitare errori di serializzazione
    for doc in dati:
        doc["_id"] = str(doc["_id"])
    return JsonResponse(dati, safe=False)


