from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.ext.asyncio import create_async_engine, AsyncSession
from sqlalchemy.orm import sessionmaker
import logging

from .core.config import settings
from .models.models import Base
from .routers import contracts, bounties, auditors

logging.basicConfig(level=logging.INFO)

app = FastAPI(title=settings.PROJECT_NAME)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"], # For dev purposes
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

engine = create_async_engine(settings.DATABASE_URL, echo=True)
async_session = sessionmaker(
    engine, class_=AsyncSession, expire_on_commit=False
)

# Dependency
async def get_db():
    async with async_session() as session:
        yield session

# Include routers
app.include_router(contracts.router)
app.include_router(bounties.router)
app.include_router(auditors.router)

@app.on_event("startup")
async def on_startup():
    async with engine.begin() as conn:
        # For simplicity in scaffolding, we create all tables here.
        # In production, use Alembic migrations.
        await conn.run_sync(Base.metadata.create_all)

@app.get("/")
def read_root():
    return {"message": "Welcome to AuditChain API"}
