from typing import List
from ai_engine.llm_analyzer import LLMAnalyzer
from ai_engine.static_analyzer import StaticAnalyzer
from ai_engine.report import merge_findings
from ai_engine.analyzer_base import Finding
from ..core.config import settings

async def analyze_contract(source: str) -> List[Finding]:
    llm = LLMAnalyzer(api_key=settings.OPENAI_API_KEY)
    static = StaticAnalyzer()

    # In a real app we might run these concurrently using asyncio.gather
    llm_findings = await llm.analyze(source)
    static_findings = await static.analyze(source)

    return merge_findings(llm_findings, static_findings)
