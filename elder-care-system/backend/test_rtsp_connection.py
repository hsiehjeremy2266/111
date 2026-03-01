import cv2
import sys
import os
from dotenv import load_dotenv

# 強制使用 UTF-8 輸出以支援中文與符號 (Windows 必要)
if sys.platform == "win32":
    import io
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

def test_rtsp():
    # 載入 .env 內的設定
    load_dotenv()
    source = os.getenv("CAMERA_SOURCE", "0")
    
    # 嘗試轉為 int (如果是 webcam)
    try:
        source = int(source)
    except:
        pass

    print(f"正在嘗試連線至: {source} ...")
    cap = cv2.VideoCapture(source)
    
    if not cap.isOpened():
        print("[X] 無法開啟影像來源。請檢查：")
        print("1. RTSP URL 格式是否正確（帳密、IP）")
        print("2. 攝影機與電腦是否在同一區域網路")
        print("3. 是否有防火牆擋住 RTSP (預設 Port 554)")
        return

    print("[V] 連線成功！正在讀取畫面...")
    
    # 讀取 30 幀來驗證穩定性
    for i in range(30):
        ret, frame = cap.read()
        if not ret:
            print(f"第 {i} 幀讀取失敗。")
            break
        
        # 顯示縮圖大小
        h, w = frame.shape[:2]
        if i == 0:
            print(f"成功獲取影像！解析度: {w}x{h}")

    cap.release()
    print("\n--- 測試完成 ---")
    print("如果看到『成功獲取影像』，代表該 URL 可以直接在長照系統中使用。")

if __name__ == "__main__":
    test_rtsp()
