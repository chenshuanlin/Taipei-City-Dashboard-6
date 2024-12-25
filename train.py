import os
import yaml
from ultralytics import YOLO

def verify_dataset():
    """驗證資料集路徑和結構"""
    base_dir = os.path.dirname(os.path.abspath(__file__))
    yaml_path = os.path.join(base_dir, 'data.yaml')
    
    # 檢查資料夾結構
    required_paths = [
        os.path.join(base_dir, 'images', 'train'),
        os.path.join(base_dir, 'images', 'val'),
        os.path.join(base_dir, 'labels', 'train'),
        os.path.join(base_dir, 'labels', 'val')
    ]
    
    for path in required_paths:
        if not os.path.exists(path):
            raise FileNotFoundError(f"找不到路徑：{path}")
            
    # 檢查 yaml 文件
    with open(yaml_path, 'r', encoding='utf-8') as f:
        data = yaml.safe_load(f)
        print("data.yaml 內容：")
        print(data)
        
    # 檢查圖片和標籤
    train_images = len(os.listdir(os.path.join(base_dir, 'images', 'train')))
    train_labels = len(os.listdir(os.path.join(base_dir, 'labels', 'train')))
    val_images = len(os.listdir(os.path.join(base_dir, 'images', 'val')))
    val_labels = len(os.listdir(os.path.join(base_dir, 'labels', 'val')))
    
    print(f"\n資料集統計：")
    print(f"訓練集：{train_images} 張圖片，{train_labels} 個標籤文件")
    print(f"驗證集：{val_images} 張圖片，{val_labels} 個標籤文件")
    
    if train_images != train_labels or val_images != val_labels:
        print("\n警告：圖片和標籤數量不匹配！請確認標籤與圖片一一對應。")
    
    return True

def train_model():
    """訓練模型"""
    try:
        # 先驗證資料集
        verify_dataset()
        
        # 確保在正確的工作目錄
        os.chdir(os.path.dirname(os.path.abspath(__file__)))
        
        # 若有 GPU，建議設置 device=0 或 'cuda:0'
        # 如果只有 CPU，就只能設 'cpu'
        device_used = 'cpu'  # 或者 0, 'cuda:0'

        # 載入 YOLOv8 模型（使用 Nano 款 yolov8n.pt）
        model = YOLO("yolov8n.pt")  # 也可嘗試 yolov8s.pt

        # 開始訓練
        results = model.train(
            data="data.yaml",          # 資料集設定
            epochs=30,                 # 訓練輪數
            imgsz=640,                 # 圖片大小
            batch=16,                  # 批次大小
            patience=10,               # 提前停止耐心值
            device=device_used,        # 使用 CPU 或 GPU
            workers=4,                 # 加載數據的線程數
            project="runs/train",      # 專案資料夾
            name="exp",                # 實驗名稱
            exist_ok=True,             # 允許覆蓋
            optimizer="AdamW",         # 優化器
            lr0=0.001,                 # 初始學習率
            lrf=0.01,                  # 最終學習率因子
            momentum=0.937,            # 動量
            weight_decay=0.0005,       # 權重衰減
            warmup_epochs=3,           # 預熱輪數
            warmup_momentum=0.8,
            warmup_bias_lr=0.1,
            degrees=10.0,              # 增加旋轉範圍，對車牌旋轉進行增強
            translate=0.1,             # 平移範圍
            scale=0.5,                 # 縮放範圍
            shear=0.0,                 # 禁用剪切
            perspective=0.0,           # 禁用透視變換
            flipud=0.0,                # 禁用上下翻轉
            fliplr=0.5,                # 左右翻轉增強
            hsv_h=0.015,               # 色調增強
            hsv_s=0.7,                 # 飽和度增強
            hsv_v=0.4,                 # 亮度增強
            mosaic=1.0,                # 如果要配合 rect=True，mosaic不一定有效，可以改為 0.5或直接關掉
            mixup=0.2,                 # 啟用 Mixup
            rect=False,                # 若要使用 mosaic/mixup，建議把 rect 關閉
            single_cls=True,           # 單類別模式 (確定只有一個車牌類別時)
            augment=True,              # 啟用自動增強
        )
        
        print("\n訓練完成！")
        print(f"模型保存在：{os.path.join(os.getcwd(), 'runs/train/exp/weights/best.pt')}")

    except Exception as e:
        print(f"\n訓練過程中發生錯誤：")
        print(f"{str(e)}")
        print("\n請檢查：")
        print("1. 確保所有檔案和資料夾名稱正確")
        print("2. 確保在正確的工作目錄中運行腳本")
        print("3. 檢查標籤文件格式是否正確")

if __name__ == "__main__":
    train_model()
