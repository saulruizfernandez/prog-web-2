from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
import json
from .mongo_client import db

@csrf_exempt  # Anyone can send a request, as is a local webservice (security dissabled)
def local_server(request):
    if request.method != "POST":
        return JsonResponse({"error": "Only POST method is allowed."}, status=405)
    try:
        payload = json.loads(request.body) # Extract json from the body of the POST request
        for table_name, records in payload.items():
            collection = db[table_name] # Create a collection for each table
            result = collection.insert_many(records) # Insert records into the collection
        return JsonResponse({"status": "success"}, status=201)
    except Exception as e:
        return JsonResponse({"error": str(e)}, status=400)
