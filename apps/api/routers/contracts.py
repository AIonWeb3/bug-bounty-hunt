from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession
from sqlalchemy.future import select
import json

from ..models.models import Contract, Report
from ..schemas.schemas import ContractUpload, ReportResponse
from ..services.analyzer_service import analyze_contract

# Assuming a dependency get_db is provided in main
from ..main import get_db

router = APIRouter(prefix="/contracts", tags=["Contracts"])

@router.post("/upload", response_model=ReportResponse)
async def upload_contract(contract_in: ContractUpload, db: AsyncSession = Depends(get_db)):
    # 1. Save contract
    new_contract = Contract(
        uploader_address=contract_in.uploader_address,
        source_code=contract_in.source_code
    )
    db.add(new_contract)
    await db.commit()
    await db.refresh(new_contract)

    # 2. Analyze
    findings = await analyze_contract(contract_in.source_code)
    
    # 3. Save report
    findings_dicts = [f.model_dump() for f in findings]
    new_report = Report(
        contract_id=new_contract.id,
        findings_json=json.dumps(findings_dicts)
    )
    db.add(new_report)
    await db.commit()
    await db.refresh(new_report)

    return ReportResponse(
        id=new_report.id,
        contract_id=new_contract.id,
        findings=findings_dicts,
        created_at=new_report.created_at
    )

@router.get("/{id}/report", response_model=ReportResponse)
async def get_report(id: int, db: AsyncSession = Depends(get_db)):
    result = await db.execute(select(Report).where(Report.contract_id == id))
    report = result.scalars().first()
    if not report:
        raise HTTPException(status_code=404, detail="Report not found")
    
    return ReportResponse(
        id=report.id,
        contract_id=report.contract_id,
        findings=json.loads(report.findings_json),
        created_at=report.created_at
    )
