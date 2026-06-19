from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    PROJECT_NAME: str = "AuditChain API"
    DATABASE_URL: str = "postgresql+asyncpg://postgres:postgres@localhost:5432/auditchain"
    OPENAI_API_KEY: str = ""

    model_config = SettingsConfigDict(env_file=".env", env_file_encoding="utf-8")

settings = Settings()
