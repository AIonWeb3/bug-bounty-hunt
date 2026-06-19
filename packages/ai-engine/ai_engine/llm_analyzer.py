import json
from typing import List
from openai import AsyncOpenAI
from .analyzer_base import AnalyzerBase, Finding

class LLMAnalyzer(AnalyzerBase):
    def __init__(self, api_key: str):
        self.client = AsyncOpenAI(api_key=api_key)

    async def analyze(self, source: str) -> List[Finding]:
        prompt = f"""
        You are a smart contract security auditor. Review the following Solidity code and identify any vulnerabilities.
        Return the results as a JSON array of objects, where each object has the following keys:
        - "severity": "High", "Medium", "Low", or "Informational"
        - "function": The name of the vulnerable function, or "Global" if it applies to the whole contract
        - "description": A clear description of the vulnerability
        - "recommendation": How to fix the vulnerability

        Code:
        ```solidity
        {source}
        ```
        """

        response = await self.client.chat.completions.create(
            model="gpt-4-turbo",
            messages=[
                {"role": "system", "content": "You are a specialized smart contract auditing AI."},
                {"role": "user", "content": prompt}
            ],
            response_format={ "type": "json_object" }
        )

        content = response.choices[0].message.content
        if not content:
            return []

        try:
            # Assuming the LLM returns {"findings": [...]} based on typical JSON responses
            data = json.loads(content)
            findings_data = data.get("findings", [])
            
            # If it returned an array directly
            if isinstance(data, list):
                findings_data = data

            return [Finding(**f) for f in findings_data]
        except Exception as e:
            print(f"Error parsing LLM output: {e}")
            return []
