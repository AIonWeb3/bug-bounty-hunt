from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import Annotated

from ..models.models import Auditor
from ..schemas.schemas import AuditorResponse
from ..main import get_db

router = APIRouter(prefix="/auditors", tags=["Auditors"])

DbSession = Annotated[AsyncSession, Depends(get_db)]

@router.get("/{address}/reputation", response_model=AuditorResponse)
async def get_reputation(address: str, db: DbSession):
    result = await db.execute(select(Auditor).where(Auditor.address == address))
    auditor = result.scalars().first()
    if not auditor:
        # Return 0 if not found
        return AuditorResponse(address=address, reputation_score=0)
    
    return AuditorResponse(address=auditor.address, reputation_score=auditor.reputation_score)

