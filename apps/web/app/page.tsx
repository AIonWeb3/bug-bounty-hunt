export default function Home() {
  return (
    <div className="max-w-4xl mx-auto text-center mt-20">
      <h1 className="text-5xl font-extrabold mb-6">AI-Powered Smart Contract Audits</h1>
      <p className="text-xl text-slate-300 mb-10">
        Upload your Solidity code, get an instant AI vulnerability report, and launch a bug bounty on-chain to attract top auditors.
      </p>
      <div className="space-x-4">
        <a href="/upload" className="bg-blue-600 hover:bg-blue-700 px-6 py-3 rounded-lg font-bold">
          Scan Contract
        </a>
        <a href="/bounties" className="bg-slate-700 hover:bg-slate-600 px-6 py-3 rounded-lg font-bold">
          Explore Bounties
        </a>
      </div>
    </div>
  )
}
