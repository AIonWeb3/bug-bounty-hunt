# AuditChain

AI-powered smart contract bug bounty platform.

## Architecture
- **Contracts**: Solidity & Foundry (Base Sepolia target)
- **Backend**: FastAPI & PostgreSQL
- **Frontend**: Next.js, Wagmi & Tailwind
- **AI Engine**: Python (OpenAI for LLM, extensible for Static Analyzers like Slither)

## Local Development Setup

### Prerequisites
- Docker & Docker Compose
- Node.js v18+
- Python 3.10+
- Foundry (`curl -L https://foundry.paradigm.xyz | bash`)

### 1. Environment Variables
Create an `.env` file in the root directory:
```bash
OPENAI_API_KEY=your_openai_api_key_here
```

### 2. Smart Contracts
```bash
cd contracts
forge install
forge test
```

To deploy to Base Sepolia:
```bash
# Add PRIVATE_KEY to your env or pass it directly
forge script script/Deploy.s.sol:DeployScript --rpc-url <BASE_SEPOLIA_RPC> --broadcast
```

### 3. Run the Stack (Docker)
This will spin up the Postgres DB, FastAPI backend, and Next.js frontend.
```bash
docker-compose up --build
```
- Frontend: http://localhost:3000
- API: http://localhost:8000
- DB: localhost:5432

### 4. Running Backend / Frontend Manually (Optional)
**API**:
```bash
cd apps/api
pip install -r requirements.txt
pip install ../../packages/ai-engine
uvicorn main:app --reload
```

**Web**:
```bash
cd apps/web
npm install
npm run dev
```

## Deployment
- **Web**: Ready for Vercel deployment (set `NEXT_PUBLIC_API_URL`).
- **API**: Ready for Render deployment (uses `Dockerfile`). Set `DATABASE_URL` and `OPENAI_API_KEY`.
