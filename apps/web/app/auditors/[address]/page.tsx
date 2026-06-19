'use client'
import { useEffect, useState } from 'react'

export default function AuditorProfile({ params }: { params: { address: string } }) {
  const [reputation, setReputation] = useState(0)

  useEffect(() => {
    fetch(`http://localhost:8000/auditors/${params.address}/reputation`)
      .then(res => res.json())
      .then(data => setReputation(data.reputation_score))
      .catch(console.error)
  }, [params.address])

  return (
    <div className="max-w-2xl mx-auto text-center mt-10">
      <div className="bg-slate-800 p-8 rounded-full inline-block mb-6">
        <span className="text-6xl">🕵️</span>
      </div>
      <h1 className="text-2xl font-mono mb-2">{params.address}</h1>
      <p className="text-slate-400 mb-6">Security Auditor</p>
      
      <div className="bg-slate-800 p-6 rounded-lg inline-block">
        <h2 className="text-xl font-bold mb-2">Reputation Score</h2>
        <div className="text-4xl text-blue-400 font-extrabold">{reputation}</div>
      </div>
    </div>
  )
}
