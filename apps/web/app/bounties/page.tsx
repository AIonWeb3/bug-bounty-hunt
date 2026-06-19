'use client'
import { useEffect, useState } from 'react'
import Link from 'next/link'

export default function BountiesPage() {
  const [bounties, setBounties] = useState([])

  useEffect(() => {
    fetch('http://localhost:8000/bounties')
      .then(res => res.json())
      .then(data => setBounties(data))
      .catch(console.error)
  }, [])

  return (
    <div className="max-w-4xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">Active Bug Bounties</h1>
      <div className="grid gap-4">
        {bounties.map((b: any) => (
          <Link key={b.id} href={`/bounties/${b.onchain_id}`}>
            <div className="p-6 bg-slate-800 rounded-lg hover:bg-slate-700 cursor-pointer">
              <div className="flex justify-between items-center">
                <div>
                  <h2 className="text-xl font-bold">Bounty #{b.onchain_id}</h2>
                  <p className="text-slate-400">Creator: {b.creator}</p>
                </div>
                <div className="text-green-400 font-bold text-lg">
                  Reward: {b.reward} Wei
                </div>
              </div>
            </div>
          </Link>
        ))}
        {bounties.length === 0 && <p>No active bounties found.</p>}
      </div>
    </div>
  )
}
