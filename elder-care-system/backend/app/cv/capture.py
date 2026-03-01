import cv2
import threading
import time
import os
from dotenv import load_dotenv

# 讀取環境變數
load_dotenv()

class VideoCapturePipeline:
    def __init__(self, source=0):
        # 嘗試從環境變數讀取 CAMERA_SOURCE，若無則使用傳入的預設值
        env_source = os.getenv("CAMERA_SOURCE", source)
        # 如果是數字字串，轉為 int（用於 webcam 索引），否則保持字串（用於 RTSP URL）
        try:
            self.source = int(env_source)
        except (ValueError, TypeError):
            self.source = env_source
            
        self.cap = cv2.VideoCapture(self.source)
        self.running = False
        self.current_frame = None
        self.lock = threading.Lock()
        print(f"[Capture] 影像來源已設定為: {self.source}")
        
    def start(self):
        self.running = True
        self.thread = threading.Thread(target=self._capture_loop, daemon=True)
        self.thread.start()
        
    def stop(self):
        self.running = False
        if hasattr(self, 'thread'):
            self.thread.join()
        if self.cap:
            self.cap.release()
            
    def _capture_loop(self):
        while self.running:
            ret, frame = self.cap.read()
            if not ret:
                print(f"[Capture] 無法擷取影像 {self.source}，嘗試重新連線...")
                self.cap.release()
                time.sleep(2)
                self.cap = cv2.VideoCapture(self.source)
                continue
                
            with self.lock:
                self.current_frame = frame
                
    def get_frame(self):
        with self.lock:
            if self.current_frame is not None:
                return self.current_frame.copy()
            return None

# 全域實例
# 優先讀取 .env
pipeline = VideoCapturePipeline()
