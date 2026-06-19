from typing import List
from .analyzer_base import Finding

SEVERITY_SCORES = {
    "High": 4,
    "Medium": 3,
    "Low": 2,
    "Informational": 1
}

def merge_findings(llm_findings: List[Finding], static_findings: List[Finding]) -> List[Finding]:
    """
    Merges findings from multiple analyzers, dedupes them by description, 
    and sorts by severity.
    """
    all_findings = llm_findings + static_findings
    
    # Deduplicate by description (simplistic deduplication for now)
    unique_findings_dict = {}
    for finding in all_findings:
        if finding.description not in unique_findings_dict:
            unique_findings_dict[finding.description] = finding
            
    unique_findings = list(unique_findings_dict.values())
    
    # Sort by severity descending
    unique_findings.sort(key=lambda x: SEVERITY_SCORES.get(x.severity, 0), reverse=True)
    
    return unique_findings
