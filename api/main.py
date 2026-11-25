from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
import psycopg
from pymongo import MongoClient

app = FastAPI(title="LegacyLedger API (Partial Output Demo)", version="0.1.0")

PG_DSN = "postgresql://legacy:legacy_dev_password@localhost:5432/legacyledger"
MONGO_URI = "mongodb://localhost:27017/"


class NominationIn(BaseModel):
    asset_id: int
    nominee_person_id: int
    appointee_person_id: int | None = None
    allocation_pct: float = Field(..., gt=0, le=100)
    is_minor: bool = False


@app.get("/health")
def health_check():
    with psycopg.connect(PG_DSN) as conn, conn.cursor() as cur:
        cur.execute("SELECT COUNT(*) FROM information_schema.tables WHERE table_schema = 'public';")
        pg_tables = cur.fetchone()[0]

    mongo_db = MongoClient(MONGO_URI)["legacyledger"]
    candidates = mongo_db["extraction_candidates"].count_documents({})
    return {"postgres_tables": pg_tables, "mongo_extraction_candidates": candidates, "status": "ok"}


@app.get("/claimants/{person_id}/assets")
def get_claimant_assets(person_id: int):
    with psycopg.connect(PG_DSN) as conn, conn.cursor() as cur:
        # Parameterized query (%s bind variable) — SQL injection safe
        cur.execute(
            """
            SELECT claimant_name, asset_id, asset_type, account_mask,
                   institution_name, workflow_id, workflow_status, access_mode
            FROM v_authorized_claimant_assets
            WHERE claimant_person_id = %s
            ORDER BY asset_id;
            """,
            (person_id,),
        )
        cols = [d[0] for d in cur.description]
        return [dict(zip(cols, row)) for row in cur.fetchall()]


@app.post("/nominations")
def create_nomination(payload: NominationIn):
    try:
        with psycopg.connect(PG_DSN) as conn, conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO nomination
                    (asset_id, nominee_person_id, appointee_person_id, allocation_pct, is_minor)
                VALUES (%s, %s, %s, %s, %s);
                """,
                (
                    payload.asset_id,
                    payload.nominee_person_id,
                    payload.appointee_person_id,
                    payload.allocation_pct,
                    payload.is_minor,
                ),
            )
            conn.commit()
        return {"status": "created", "nomination": payload.model_dump()}
    except psycopg.Error as e:
        raise HTTPException(status_code=400, detail=str(e).strip())
