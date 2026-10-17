"""Check that the project can connect to the local PostgreSQL database.

Reads settings from a .env file next to this script. The .env file is never committed.

Run from the project folder, using the project's virtual environment:
    .venv\\Scripts\\python.exe check_connection.py
"""

from pathlib import Path

import psycopg2


def load_env(path: Path) -> dict:
    """Read KEY=VALUE lines from a .env file. Skips blank lines and # comments."""
    values = {}
    for line in path.read_text(encoding="utf-8").splitlines():
        line = line.strip()
        if not line or line.startswith("#") or "=" not in line:
            continue
        key, value = line.split("=", 1)
        values[key.strip()] = value.strip()
    return values


def main() -> None:
    env_path = Path(__file__).resolve().parent / ".env"
    if not env_path.exists():
        raise SystemExit("No .env file found. Copy .env.example to .env and fill in PGPASSWORD.")

    cfg = load_env(env_path)
    conn = psycopg2.connect(
        host=cfg["PGHOST"],
        port=cfg["PGPORT"],
        dbname=cfg["PGDATABASE"],
        user=cfg["PGUSER"],
        password=cfg["PGPASSWORD"],
    )
    with conn.cursor() as cur:
        cur.execute("select version();")
        print("Connected:", cur.fetchone()[0])
    conn.close()


if __name__ == "__main__":
    main()
