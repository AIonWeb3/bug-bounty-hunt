import pytest
from unittest.mock import AsyncMock, patch
from ai_engine.llm_analyzer import LLMAnalyzer
from ai_engine.analyzer_base import Finding
import json

@pytest.mark.asyncio
async def test_llm_analyzer_success():
    analyzer = LLMAnalyzer(api_key="fake-key")
    
    # Mock the AsyncOpenAI client
    with patch("ai_engine.llm_analyzer.AsyncOpenAI") as MockClient:
        mock_instance = MockClient.return_value
        mock_response = AsyncMock()
        
        mock_message = AsyncMock()
        mock_message.content = json.dumps({
            "findings": [
                {
                    "severity": "High",
                    "function": "withdraw",
                    "description": "Reentrancy vulnerability",
                    "recommendation": "Use checks-effects-interactions pattern"
                }
            ]
        })
        
        mock_choice = AsyncMock()
        mock_choice.message = mock_message
        mock_response.choices = [mock_choice]
        
        mock_instance.chat.completions.create = AsyncMock(return_value=mock_response)
        
        # Override the analyzer's client with our mock
        analyzer.client = mock_instance
        
        findings = await analyzer.analyze("contract Vulnerable { ... }")
        
        assert len(findings) == 1
        assert findings[0].severity == "High"
        assert findings[0].function == "withdraw"
        assert findings[0].description == "Reentrancy vulnerability"
