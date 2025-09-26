from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
import redis.asyncio as redis
import socketio
import os
from pydantic import BaseModel
from typing import Optional
import asyncio

# Modèles de données
class Vote(BaseModel):
    firstname: str
    lastname: str
    gender: Optional[str] = ""
    vote: str

class VoteResult(BaseModel):
    choice: str
    votes: int

# Configuration Redis
REDIS_URL = os.getenv("REDIS_URL", "redis://localhost:6379")

# Initialisation Socket.IO AVANT FastAPI
sio = socketio.AsyncServer(async_mode='asgi', cors_allowed_origins="*")

# Initialisation FastAPI
app = FastAPI(title="Système de Vote", version="1.0.0")

# CORS pour permettre les requêtes du frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Autoriser toutes les origines pour le debug
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Monter Socket.IO sur FastAPI
socket_app = socketio.ASGIApp(sio, app)

# Connexion Redis
@app.on_event("startup")
async def startup_event():
    app.redis = redis.from_url(REDIS_URL, decode_responses=True)
    try:
        await app.redis.ping()
        print("✅ Connecté à Redis")
    except Exception as e:
        print(f"❌ Erreur connexion Redis: {e}")

@app.on_event("shutdown")
async def shutdown_event():
    if hasattr(app, 'redis'):
        await app.redis.close()

# Routes API
@app.post("/vote", response_model=dict)
async def submit_vote(vote_data: Vote):
    try:
        voter_id = f"voter:{vote_data.firstname}:{vote_data.lastname}"
        
        # Vérifier si déjà voté
        existing_vote = await app.redis.hget(voter_id, "vote")
        if existing_vote:
            raise HTTPException(status_code=400, detail="Vous avez déjà voté !")
        
        # Stocker les infos du votant
        voter_data = {
            "gender": vote_data.gender or "Non spécifié",
            "vote": vote_data.vote
        }
        
        await app.redis.hset(voter_id, mapping=voter_data)
        await app.redis.zincrby("votes:total", 1, vote_data.vote)
        
        # Récupérer les nouveaux résultats
        results = await get_vote_results()
        
        # Notifier via WebSocket
        results_dict = [{"choice": r.choice, "votes": r.votes} for r in results]
        await sio.emit("results_update", results_dict)
        
        # Message de confirmation
        title = "M." if vote_data.gender == "M" else "Mme" if vote_data.gender == "F" else ""
        return {
            "message": f"Merci {title} {vote_data.firstname} {vote_data.lastname}, vous avez voté pour {vote_data.vote}."
        }
        
    except Exception as e:
        print(f"❌ Erreur lors du vote: {e}")
        raise HTTPException(status_code=500, detail="Erreur interne du serveur")

@app.get("/results", response_model=list[VoteResult])
async def get_results():
    try:
        return await get_vote_results()
    except Exception as e:
        print(f"❌ Erreur récupération résultats: {e}")
        raise HTTPException(status_code=500, detail="Erreur lors de la récupération des résultats")

async def get_vote_results():
    try:
        results = await app.redis.zrange("votes:total", 0, -1, withscores=True)
        vote_results = []
        
        for choice, score in results:
            vote_results.append(VoteResult(choice=choice, votes=int(score)))
        
        vote_results.sort(key=lambda x: x.votes, reverse=True)
        return vote_results
        
    except Exception as e:
        print(f"❌ Erreur dans get_vote_results: {e}")
        return []

# Événements Socket.IO
@sio.event
async def connect(sid, environ):
    print(f"✅ Client WebSocket connecté: {sid}")

@sio.event
async def disconnect(sid):
    print(f"🔌 Client WebSocket déconnecté: {sid}")

# Route de santé
@app.get("/health")
async def health_check():
    return {"status": "healthy", "service": "vote-backend"}

# Point d'entrée pour Socket.IO
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(socket_app, host="0.0.0.0", port=8000, reload=True)