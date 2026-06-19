'use client'

import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { WagmiProvider } from 'wagmi'
import { config } from '../lib/wagmi'
import './globals.css'
import Link from 'next/link'

const queryClient = new QueryClient()

export default function RootLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <html lang="en">
      <body>
        <WagmiProvider config={config}>
          <QueryClientProvider client={queryClient}>
            <div className="min-h-screen flex flex-col">
              <nav className="p-4 bg-slate-800 flex justify-between items-center">
                <div className="text-xl font-bold text-blue-400">
                  <Link href="/">AuditChain</Link>
                </div>
                <div className="space-x-4">
                  <Link href="/upload" className="hover:text-blue-300">Upload</Link>
                  <Link href="/bounties" className="hover:text-blue-300">Bounties</Link>
                </div>
              </nav>
              <main className="flex-1 p-8">
                {children}
              </main>
            </div>
          </QueryClientProvider>
        </WagmiProvider>
      </body>
    </html>
  )
}
