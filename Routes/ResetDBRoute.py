from fastapi import APIRouter, HTTPException, status, Request
import os

router = APIRouter()

SQL_FILE_PATH = os.path.join(
    os.path.dirname(__file__), "..", "music_app_schema_with_data.sql"
)
DB_FILE_PATH = os.path.join(os.path.dirname(__file__), "..", "store.db")


@router.post("/reset-db", status_code=status.HTTP_200_OK)
async def reset_db(request: Request):

    import sqlite3

    try:
        with open(SQL_FILE_PATH, encoding="utf-8") as f:
            sql_script = f.read()
        conn = sqlite3.connect(DB_FILE_PATH)
        conn.executescript(sql_script)
        conn.close()
        return {"detail": "Database reset successfully."}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Database reset failed: {e}")
