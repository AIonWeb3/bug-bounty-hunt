from pydantic import BaseModel
from typing import List, Optional
from datetime import datetime

class ContractUpload(BaseModel):
    uploader_address: str
    source_code: str

class FindingSchema(BaseModel):
    severity: str
    function: str
    description: str
    recommendation: str

class ReportResponse(BaseModel):
    id: int
    contract_id: int
    findings: List[FindingSchema]
    created_at: datetime

class BountyCreate(BaseModel):
    onchain_id: int
    creator: str
    reward: str

class BountyResponse(BaseModel):
    id: int
    onchain_id: int
    creator: str
    reward: str
    is_active: bool

class AuditorResponse(BaseModel):
    address: str
    reputation_score: int
