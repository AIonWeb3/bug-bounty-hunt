'use client'
import { useState } from 'react'

export default function UploadPage() {
  const [source, setSource] = useState('')
  const [report, setReport] = useState<any>(null)
  const [loading, setLoading] = useState(false)

  const handleUpload = async () => {
    setLoading(true)
    try {
      const res = await fetch('http://localhost:8000/contracts/upload', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ uploader_address: '0x123', source_code: source })
      })
      const data = await res.json()
      setReport(data)
    } catch (e) {
      console.error(e)
    }
    setLoading(false)
  }

  return (
    <div className="max-w-3xl mx-auto">
      <h1 className="text-3xl font-bold mb-4">Upload Contract</h1>
      <textarea
        className="w-full h-64 p-4 bg-slate-800 rounded-lg mb-4 text-slate-200 font-mono"
        placeholder="Paste Solidity code here..."
        value={source}
        onChange={e => setSource(e.target.value)}
      />
      <button 
        onClick={handleUpload}
        className="bg-blue-600 hover:bg-blue-700 px-6 py-2 rounded font-bold"
        disabled={loading}
      >
        {loading ? 'Analyzing...' : 'Analyze'}
      </button>

      {report && (
        <div className="mt-8 p-6 bg-slate-800 rounded-lg">
          <h2 className="text-2xl font-bold mb-4">Vulnerability Report</h2>
          {report.findings.map((f: any, i: number) => (
            <div key={i} className="mb-4 p-4 bg-slate-700 rounded border-l-4 border-red-500">
              <h3 className="font-bold text-lg">{f.severity} - {f.function}</h3>
              <p className="mt-2 text-slate-300">{f.description}</p>
              <p className="mt-2 text-green-400 font-mono text-sm">Fix: {f.recommendation}</p>
            </div>
          ))}
        </div>
      )}
    </div>
  )
}
