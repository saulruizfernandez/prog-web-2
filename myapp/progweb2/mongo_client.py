from pymongo import MongoClient

client = MongoClient("mongodb://localhost:27017/")
db = client["prog_web2"]  # Sostituisci con il nome del tuo database