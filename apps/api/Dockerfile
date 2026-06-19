FROM python:3.10-slim

WORKDIR /app

COPY packages/ai-engine /packages/ai-engine
COPY apps/api/requirements.txt .

RUN pip install /packages/ai-engine
RUN pip install --no-cache-dir -r requirements.txt

COPY apps/api /app

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
