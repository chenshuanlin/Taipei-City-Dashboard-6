import cv2
import numpy as np
import easyocr
import logging
import sys
import os
import time
import re

# 設置日誌
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler(sys.stdout), logging.FileHandler('plate_recognition.log')]
)

# 放大影像，並使用插值方法保證清晰度
def resize_image(img, scale_factor=2):
    width = int(img.shape[1] * scale_factor)
    height = int(img.shape[0] * scale_factor)
    return cv2.resize(img, (width, height), interpolation=cv2.INTER_CUBIC)

# 增強圖像對比度
def enhance_image(image):
    # 如果是彩色圖像，先轉換為灰階
    if len(image.shape) == 3:
        image = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    # 增強對比度
    enhanced_image = cv2.equalizeHist(image)
    return enhanced_image

# 修正字符，將易混淆的字符（I->1, O->0, S->5）進行處理
def correct_text(text):
    corrected_text = text.replace("I", "1").replace("O", "0").replace("S", "5").replace("Z", "2")
    return corrected_text

# 過濾掉不符合車牌格式的識別結果（如不應該出現的數字或字符）
def filter_plate_text(text):
    if re.match(r'^[A-Z0-9-]{5,10}$', text):  # 車牌號碼長度篩選
        return text
    return None

# 使用霍夫變換檢測直線來估算旋轉角度
def detect_rotation_angle(image):
    edges = cv2.Canny(image, 50, 150, apertureSize=3)
    lines = cv2.HoughLines(edges, 1, np.pi / 180, 100)
    
    if lines is not None:
        angles = []
        for rho, theta in lines[:, 0]:
            angle = np.degrees(theta) - 90
            angles.append(angle)
        # 返回最常見的角度
        return np.median(angles)
    return 0  # 沒有檢測到直線，返回 0

# 旋轉矯正
def correct_rotation(image, angle):
    (h, w) = image.shape[:2]
    M = cv2.getRotationMatrix2D((w / 2, h / 2), angle, 1.0)
    rotated_image = cv2.warpAffine(image, M, (w, h))
    return rotated_image

# 嘗試多次讀取圖片
def retry_read_image(image_path, retry_count=3, delay=1):
    attempt = 0
    while attempt < retry_count:
        try:
            # 使用 IMREAD_COLOR 直接讀取彩色圖像
            img = cv2.imread(image_path, cv2.IMREAD_COLOR)
            if img is not None:
                return img
            time.sleep(delay)
        except Exception as e:
            logging.error(f"讀取圖片時發生錯誤: {str(e)}")
        attempt += 1
    return None  # 無法讀取圖片

# 進行車牌辨識
def process_images():
    try:
        logging.info("初始化 OCR 引擎...")
        reader = easyocr.Reader(['en'], gpu=False)

        base_dir = os.path.abspath(".")
        images_dir = os.path.join(base_dir, "images", "train")
        results_dir = os.path.join(base_dir, "results")

        os.makedirs(results_dir, exist_ok=True)

        image_files = [f for f in os.listdir(images_dir) if f.lower().endswith(('.jpg', '.jpeg', '.png'))]

        if not image_files:
            logging.error(f"在 {images_dir} 中找不到圖片")
            return

        logging.info(f"找到 {len(image_files)} 張圖片")

        for image_file in image_files:
            try:
                logging.info(f"處理: {image_file}")

                image_path = os.path.join(images_dir, image_file)
                img = retry_read_image(image_path)
                if img is None:
                    logging.warning(f"無法讀取圖片: {image_path}, 跳過...")
                    continue

                # 放大影像並增強
                img_resized = resize_image(img, scale_factor=2)
                
                # 增強圖像
                enhanced_img = enhance_image(img_resized)

                # 檢測圖片的旋轉角度
                angle = detect_rotation_angle(enhanced_img)
                if abs(angle) > 5:  # 設置閾值檢測是否需要旋轉
                    img_resized = correct_rotation(img_resized, angle)

                # 進行車牌識別
                results = reader.readtext(
                    enhanced_img,
                    allowlist='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-',
                    detail=1
                )

                # 如果第一次辨識無結果，對整張圖片進行OCR辨識
                if not results:
                    logging.info("第一次辨識無結果，對整張圖片進行OCR...")
                    results = reader.readtext(
                        img_resized,
                        allowlist='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-',
                        detail=1
                    )

                # 儲存所有結果，並根據信心度選擇最優結果
                best_result = None
                best_confidence = 0

                for (bbox, text, prob) in results:
                    corrected_text = correct_text(text)
                    filtered_text = filter_plate_text(corrected_text)
                    if filtered_text and prob > best_confidence:
                        best_result = filtered_text
                        best_confidence = prob

                # 儲存最佳識別結果，並標註在原圖上
                if best_result:
                    logging.info(f"最佳車牌識別結果：{best_result}（信心度: {best_confidence:.2f}）")
                    # 在圖像上繪製車牌位置和識別結果
                    for (bbox, text, prob) in results:
                        if correct_text(text) == best_result:  # 繪製最佳結果的框
                            cv2.rectangle(img_resized, 
                                          (int(bbox[0][0]), int(bbox[0][1])), 
                                          (int(bbox[2][0]), int(bbox[2][1])), 
                                          (0, 255, 0), 2)
                            cv2.putText(img_resized, f"{best_result} ({best_confidence:.2f})", 
                                        (int(bbox[0][0]), int(bbox[0][1]) - 10),
                                        cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 255, 0), 2)

                    # 儲存結果
                    cv2.imwrite(os.path.join(results_dir, f"result_{image_file}"), img_resized)
                else:
                    logging.warning(f"無法辨識任何車牌: {image_file}")

            except Exception as e:
                logging.error(f"處理 {image_file} 時發生錯誤: {str(e)}")
                continue

        logging.info("處理完成")

    except Exception as e:
        logging.error(f"程式執行錯誤: {str(e)}")

if __name__ == "__main__":
    process_images()
