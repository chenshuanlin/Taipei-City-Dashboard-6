import cv2
import numpy as np
import easyocr
import logging
import sys
import os
import time
import re
import random

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler(sys.stdout), logging.FileHandler('plate_recognition.log')]
)

def generate_taipei_coordinates_and_address():
    """
    隨機生成台北市範圍的經緯度與假地址。
    """
    taipei_addresses = [
        "台北市中正區忠孝西路1段3號",
        "台北市信義區市府路45號",
        "台北市大安區敦化南路2段201號",
        "台北市內湖區瑞光路456號",
        "台北市文山區興隆路三段230號",
        "台北市松山區南京東路五段12號",
        "台北市士林區基河路123號",
        "台北市北投區石牌路二段50號",
        "台北市中山區民權東路三段200號",
        "台北市萬華區西園路二段88號"
    ]
    latitude = round(random.uniform(25.02, 25.15), 6)
    longitude = round(random.uniform(121.50, 121.61), 6)
    address = random.choice(taipei_addresses)
    return latitude, longitude, address

def generate_speed_limit_and_actual_speed():
    """
    隨機生成超速資訊，包含速限和實際車速。
    """
    speed_limit = random.choice([50, 60, 70])  # 台北市速限 (假設)
    actual_speed = random.randint(speed_limit + 10, speed_limit + 50)  # 隨機超速範圍
    return speed_limit, actual_speed

def correct_text(text):
    """
    將易混淆的字元做替換:
    I -> 1, O -> 0, S -> 5, Z -> 2
    """
    return text.replace("I", "1").replace("O", "0").replace("S", "5").replace("Z", "2")

def filter_plate_text(text):
    """
    過濾車牌文字:
    - 目前使用簡單的 [A-Z0-9-]{5,10}
    - 若你的車牌有更固定格式，如: 3碼英文 + 4碼數字，可再用更嚴格的正則
    """
    if re.match(r'^[A-Z0-9-]{5,10}$', text):
        return text
    return None

def process_images():
    try:
        logging.info("初始化 OCR 引擎...")
        reader = easyocr.Reader(['en'], gpu=False)

        base_dir = os.path.abspath(".")
        images_dir = os.path.join(base_dir, "images", "train")
        results_dir = os.path.join(base_dir, "results")

        os.makedirs(results_dir, exist_ok=True)

        image_files = [
            f for f in os.listdir(images_dir) 
            if f.lower().endswith(('.jpg', '.jpeg', '.png'))
        ]

        if not image_files:
            logging.error(f"在 {images_dir} 中找不到圖片")
            return

        logging.info(f"找到 {len(image_files)} 張圖片")

        for image_file in image_files:
            try:
                logging.info(f"處理: {image_file}")
                image_path = os.path.join(images_dir, image_file)
                img = cv2.imread(image_path)
                if img is None:
                    logging.warning(f"無法讀取圖片: {image_path}, 跳過...")
                    continue

                # (1) 放大影像
                img_resized = resize_image(img, scale_factor=2, interpolation=cv2.INTER_CUBIC)

                # (2) 增強影像
                enhanced_img = enhance_image(img_resized)

                # (3) OCR 辨識
                results = reader.readtext(enhanced_img, allowlist='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-', detail=1)
                best_result = "UNKNOWN"
                best_confidence = 0.0

                for (bbox, text, prob) in results:
                    corrected = correct_text(text)
                    filtered = filter_plate_text(corrected)
                    if filtered and prob > best_confidence:
                        best_result = filtered
                        best_confidence = prob

                # (4) 隨機生成經緯度與地址
                latitude, longitude, address = generate_taipei_coordinates_and_address()

                # (5) 隨機生成速限與實際車速
                speed_limit, actual_speed = generate_speed_limit_and_actual_speed()

                # 在終端機顯示車牌號碼、經緯度、地址和超速資訊
                logging.info(f"車牌號碼: {best_result}, 經緯度: {latitude}, {longitude}, 地址: {address}")
                logging.info(f"速限: {speed_limit} km/h, 實際車速: {actual_speed} km/h")

                # (6) 在圖片上顯示資訊
                cv2.putText(
                    img_resized, 
                    f"Plate: {best_result}", 
                    (10, 50), 
                    cv2.FONT_HERSHEY_SIMPLEX, 
                    1, 
                    (0, 255, 255), 
                    2
                )
                cv2.putText(
                    img_resized, 
                    f"Lat, Lon: {latitude}, {longitude}", 
                    (10, 100), 
                    cv2.FONT_HERSHEY_SIMPLEX, 
                    1, 
                    (0, 255, 255), 
                    2
                )
                cv2.putText(
                    img_resized, 
                    f"Address: {address}", 
                    (10, 150), 
                    cv2.FONT_HERSHEY_SIMPLEX, 
                    1, 
                    (0, 255, 255), 
                    2
                )
                cv2.putText(
                    img_resized, 
                    f"Speed: {actual_speed} km/h (Limit: {speed_limit} km/h)", 
                    (10, 200), 
                    cv2.FONT_HERSHEY_SIMPLEX, 
                    1, 
                    (0, 255, 255), 
                    2
                )

                # 儲存結果圖片
                cv2.imwrite(os.path.join(results_dir, f"result_{image_file}"), img_resized)

            except Exception as e:
                logging.error(f"處理 {image_file} 時發生錯誤: {str(e)}")
                continue

        logging.info("處理完成")

    except Exception as e:
        logging.error(f"程式執行錯誤: {str(e)}")

if __name__ == "__main__":
    process_images()
