from abc import ABC, abstractmethod
from typing import List
from pydantic import BaseModel

class Finding(BaseModel):
    severity: str  # "High", "Medium", "Low", "Informational"
    function: str
    description: str
    recommendation: str

class AnalyzerBase(ABC):
    @abstractmethod
    async def analyze(self, source: str) -> List[Finding]:
        """
        Analyzes the provided Solidity source code and returns a list of findings.
        """
        pass
