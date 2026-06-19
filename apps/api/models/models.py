from sqlalchemy import Column, Integer, String, Text, Boolean, ForeignKey, DateTime
from sqlalchemy.orm import declarative_base, relationship
from datetime import datetime

Base = declarative_base()

class Contract(Base):
    __tablename__ = "contracts"

    id = Column(Integer, primary_key=True, index=True)
    uploader_address = Column(String, index=True)
    source_code = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)

    reports = relationship("Report", back_populates="contract")

class Report(Base):
    __tablename__ = "reports"

    id = Column(Integer, primary_key=True, index=True)
    contract_id = Column(Integer, ForeignKey("contracts.id"))
    findings_json = Column(Text)  # Store findings as serialized JSON
    created_at = Column(DateTime, default=datetime.utcnow)

    contract = relationship("Contract", back_populates="reports")

class Bounty(Base):
    __tablename__ = "bounties"

    id = Column(Integer, primary_key=True, index=True)
    onchain_id = Column(Integer, unique=True, index=True)
    creator = Column(String, index=True)
    reward = Column(String) # Wei as string
    is_active = Column(Boolean, default=True)

class Auditor(Base):
    __tablename__ = "auditors"

    id = Column(Integer, primary_key=True, index=True)
    address = Column(String, unique=True, index=True)
    reputation_score = Column(Integer, default=0)
