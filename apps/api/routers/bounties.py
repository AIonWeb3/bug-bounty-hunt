from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
from typing import Annotated, List

from ..models.models import Bounty
from ..schemas.schemas import BountyCreate, BountyResponse
from ..main import get_db

router = APIRouter(prefix="/bounties", tags=["Bounties"])

DbSession = Annotated[AsyncSession, Depends(get_db)]

@router.post("", response_model=BountyResponse)
async def create_bounty(bounty_in: BountyCreate, db: DbSession):
    new_bounty = Bounty(**bounty_in.model_dump())
    db.add(new_bounty)
    await db.commit()
    await db.refresh(new_bounty)
    return new_bounty

@router.get("", response_model=List[BountyResponse])
async def get_bounties(db: DbSession):
    result = await db.execute(select(Bounty).where(Bounty.is_active == True))
    bounties = result.scalars().all()
    return bounties

