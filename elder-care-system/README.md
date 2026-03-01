# Elderly Long-term Care Visual Anomaly Detection System

A complete, privacy-focused, real-time visual monitoring system for elderly care using MediaPipe, FastAPI, React, and LINE Messaging API.

## Features
- **Real-time Posture & Face Detection**: Uses MediaPipe for rapid local ML inference.
- **Anomaly Detection Rules**: Detects falls (sudden laying posture) and abnormal inactivity.
- **LINE Notifications**: Instantly pushes alerts with snapshots to caregivers.
- **Privacy First**: All calculations are done locally; only anomaly events are transmitted.
- **Modern Dashboard**: React + Vite + Tailwind CSS dashboard with a dark mode aesthetic.
- **Local SQLite DB**: Zero-configuration needed for edge deployment (e.g. Raspberry Pi).

## Prerequisites
- Docker & Docker Compose
- A standard USB Webcam attached to the host machine
- LINE Channel Access Token (Optional, for notifications)

## Quick Start (Docker)

The easiest way to run the entire system is via Docker Compose.

1. Create a `.env` file in the `backend/` directory based on the `.env.example` (or configure your LINE tokens).
2. Ensure you have a webcam plugged in (Docker mapping defaults to `/dev/video0` on Linux. On Windows/Mac, you might need to adjust the device mount or run the API natively).
3. Build and launch:
   ```bash
   docker-compose up --build
   ```

4. **Access the Dashboard**: Open your browser and navigate to `http://localhost:5173`.
   - **Username**: `caregiver_01` (or register a new user using the `/auth/register` API endpoint).
   - **Password**: `password123`
5. **API Docs**: Access the FastAPI Swagger UI at `http://localhost:8000/docs`.

### Local Development (Native)

If you have issues mounting webcams into Docker, run natively:

**Terminal 1 (Backend & CV):**
```bash
cd backend
python -m venv venv
source venv/bin/activate  # or .\venv\Scripts\activate on Windows
pip install -r requirements.txt
alembic upgrade head
uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
```

**Terminal 2 (Frontend React):**
```bash
cd frontend
npm install
npm run dev
```

## Creating a Caregiver User
Since there is no default user pre-seeded in the DB, run the following Python snippet in the `backend/` directory while the DB is configured:

```python
from app.db.database import SessionLocal
from app.db.models import User
from app.core.security import get_password_hash

db = SessionLocal()
u = User(username="caregiver_01", hashed_password=get_password_hash("password123"))
db.add(u)
db.commit()
print("User created!")
```

## Architecture
- **Backend Model Layer**: SQLAlchemy mapped to `elder_care.db`. Data points include `ActivityLog`, `Event`, `Elder`, and `Baseline`.
- **CV Processor**: Captures webcam stream continuously on a thread (`app/cv/capture.py`), runs MediaPipe Face/Pose extraction, and matches embeddings (`app/cv/processor.py`).
- **Anomaly Engine**: Checks the posture heuristics (e.g. shoulder and hip deltas) against basic rules to trigger LINE alerts and insert `Event` rows.
- **Frontend Dashboard**: Fetches REST hooks periodically to update the statistics logs, while streaming an MJPEG endpoint `<img src="http://localhost:8000/video/stream" />` directly from the backend for sub-second latency video.
