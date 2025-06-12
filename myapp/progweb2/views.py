from django.shortcuts import render
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from django.http import JsonResponse
from .mongo_client import db
import json

@csrf_exempt  # Disabilita CSRF solo per test, rimuovi in produzione!
def serverlocal(request):
    if request.method == "POST":
        try:
            dati = json.loads(request.body)
            # Modifica i dati come vuoi, ad esempio aggiungi un campo
            if isinstance(dati, dict):
                dati["migrato"] = True
                dati_da_inserire = [dati]
            elif isinstance(dati, list):
                for doc in dati:
                    doc["migrato"] = True
                dati_da_inserire = dati
            else:
                return JsonResponse({"errore": "Formato dati non valido"}, status=400)

            collezione = db["tab1"]
            result = collezione.insert_many(dati_da_inserire) if isinstance(dati_da_inserire, list) else collezione.insert_one(dati_da_inserire)
            return JsonResponse({"status": "ok", "inserted_ids": [str(_id) for _id in (result.inserted_ids if hasattr(result, "inserted_ids") else [result.inserted_id])]})
        except Exception as e:
            return JsonResponse({"errore": str(e)}, status=400)
    else:
        return JsonResponse({"errore": "Metodo non consentito"}, status=405)