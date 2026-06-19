'use client'
import { useState } from 'react'
import { useAccount, useWriteContract } from 'wagmi'

// Assuming a simplified ABI for the BountyEscrow
const BountyEscrowABI = [
  {"inputs":[{"internalType":"uint256","name":"bountyId","type":"uint256"},{"internalType":"string","name":"descriptionHash","type":"string"}],"name":"submitFinding","outputs":[],"stateMutability":"nonpayable","type":"function"}
]
const CONTRACT_ADDRESS = "0x..." // TODO: Replace with deployed address

export default function BountyDetail({ params }: { params: { id: string } }) {
  const { address } = useAccount()
  const { writeContract } = useWriteContract()
  const [hash, setHash] = useState('')

  const handleSubmit = () => {
    writeContract({
      address: CONTRACT_ADDRESS,
      abi: BountyEscrowABI,
      functionName: 'submitFinding',
      args: [BigInt(params.id), hash],
    })
  }

  return (
    <div className="max-w-2xl mx-auto">
      <h1 className="text-3xl font-bold mb-6">Submit Finding for Bounty #{params.id}</h1>
      <div className="bg-slate-800 p-6 rounded-lg">
        <label className="block mb-2">Report IPFS Hash / Pointer</label>
        <input 
          type="text" 
          className="w-full p-2 bg-slate-700 rounded mb-4"
          value={hash}
          onChange={e => setHash(e.target.value)}
        />
        <button 
          onClick={handleSubmit}
          className="bg-green-600 hover:bg-green-700 px-6 py-2 rounded font-bold"
        >
          Submit On-Chain
        </button>
      </div>
    </div>
  )
}
