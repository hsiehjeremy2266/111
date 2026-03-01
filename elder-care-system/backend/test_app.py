import cv2
from sqlalchemy.orm import Session
from app.api import dashboard
from app.db.database import SessionLocal
from app.cv.processor import processor

# Mock dependencies
db = SessionLocal()

def test_elder_fetch():
    elders = dashboard.get_elders(db, current_user=None)
    assert isinstance(elders, list)
    print("REST API test passed.")

def test_posture_logic():
    # Empty landmakrs test
    res = processor.determine_posture(None)
    assert res == "Unknown"
    print("CV Posture test passed.")

if __name__ == "__main__":
    test_elder_fetch()
    test_posture_logic()
