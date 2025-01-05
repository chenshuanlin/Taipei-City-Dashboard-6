import cv2
import numpy as np
import easyocr
import logging
import sys
import os
import time
import re

logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[logging.StreamHandler(sys.stdout), logging.FileHandler('plate_recognition.log')]
)

def unsharp_mask(image, kernel_size=(5, 5), sigma=1.0, amount=1.5, threshold=0):
    """
    反遮罩銳化 (Unsharp Masking)
    image: 灰階或彩色影像皆可
    kernel_size: 高斯模糊核大小
    sigma: 高斯模糊標準差
    amount: 銳化強度
    threshold: 閾值 (控制只有差異大於 threshold 的像素才被增強)
    """
    # 1. 先對影像做高斯模糊
    blurred = cv2.GaussianBlur(image, kernel_size, sigma)
    # 2. 建立一張與輸入影像尺寸相同的遮罩(差異圖)
    sharpened = float(amount + 1) * image - float(amount) * blurred
    sharpened = np.maximum(sharpened, np.zeros(sharpened.shape))  # 去掉負值
    sharpened = np.minimum(sharpened, 255 * np.ones(sharpened.shape))  # 上限255
    sharpened = sharpened.round().astype(np.uint8)

    if threshold > 0:
        # 若像素差值小於 threshold，則不做增強
        low_contrast_mask = np.abs(image - blurred) < threshold
        np.copyto(sharpened, image, where=low_contrast_mask)

    return sharpened

def adjust_gamma(image, gamma=1.0):
    invGamma = 1.0 / gamma
    table = np.array([
        ((i / 255.0) ** invGamma) * 255 
        for i in range(256)
    ]).astype("uint8")
    return cv2.LUT(image, table)

def clahe_enhance(gray_img):
    clahe = cv2.createCLAHE(clipLimit=2.0, tileGridSize=(8, 8))
    return clahe.apply(gray_img)

def resize_image(img, scale_factor=2, interpolation=cv2.INTER_CUBIC):
    h, w = img.shape[:2]
    new_w = int(w * scale_factor)
    new_h = int(h * scale_factor)
    return cv2.resize(img, (new_w, new_h), interpolation=interpolation)

def enhance_image(image):
    """
    對影像進行一系列增強:
    1. Gamma 校正
    2. 去噪
    3. 灰階 + CLAHE
    4. Unsharp Mask 銳化
    5. Canny 邊緣
    6. 形態學運算 (OPEN -> CLOSE)
    """
    # (1) Gamma 校正 (可視情況再微調 gamma)
    gamma_corrected = adjust_gamma(image, gamma=1.3)

    # (2) 去噪 (fastNlMeansDenoising 針對亮度雜訊有幫助，可依情況嘗試其他方法)
    denoised = cv2.fastNlMeansDenoising(gamma_corrected, None, 30, 7, 21)

    # (3) 灰階化 + CLAHE
    gray = denoised if len(denoised.shape) == 2 else cv2.cvtColor(denoised, cv2.COLOR_BGR2GRAY)
    clahe_img = clahe_enhance(gray)

    # (4) Unsharp Mask 銳化
    #    - 視實際影像情況可調 kernel_size, amount
    sharpened = unsharp_mask(clahe_img, kernel_size=(5, 5), sigma=1.0, amount=1.2, threshold=5)

    # (5) Canny 邊緣偵測 (可試不同閾值如 50,150 或 80,200 ...)
    edges = cv2.Canny(sharpened, 50, 150)

    # (6) 形態學運算: 先 OPEN 去小雜訊，再 CLOSE 補邊緣
    kernel = np.ones((3, 3), np.uint8)
    opened = cv2.morphologyEx(edges, cv2.MORPH_OPEN, kernel, iterations=1)
    closed = cv2.morphologyEx(opened, cv2.MORPH_CLOSE, kernel, iterations=1)
    return closed

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

def detect_rotation_angle(image):
    """
    利用霍夫變換偵測直線，估算影像旋轉角度
    """
    edges = cv2.Canny(image, 50, 150, apertureSize=3)
    lines = cv2.HoughLines(edges, 1, np.pi / 180, 100)
    if lines is not None:
        angles = []
        for rho, theta in lines[:, 0]:
            angle = np.degrees(theta) - 90
            angles.append(angle)
        return np.median(angles)
    return 0

def correct_rotation(image, angle):
    """
    旋轉校正
    """
    (h, w) = image.shape[:2]
    M = cv2.getRotationMatrix2D((w / 2, h / 2), angle, 1.0)
    return cv2.warpAffine(image, M, (w, h))

def retry_read_image(image_path, retry_count=3, delay=1):
    """
    讀取圖片，若失敗則重試
    """
    attempt = 0
    while attempt < retry_count:
        try:
            img = cv2.imread(image_path, cv2.IMREAD_COLOR)
            if img is not None:
                return img
            time.sleep(delay)
        except Exception as e:
            logging.error(f"讀取圖片時發生錯誤: {str(e)}")
        attempt += 1
    return None

def process_images():
    try:
        logging.info("初始化 OCR 引擎...")
        # 若需要同時辨識英文+數字以外的字符(例如中文)，可再加進 language list
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
                img = retry_read_image(image_path)
                if img is None:
                    logging.warning(f"無法讀取圖片: {image_path}, 跳過...")
                    continue

                # (1) 放大影像
                img_resized = resize_image(img, scale_factor=2, interpolation=cv2.INTER_CUBIC)

                # (2) 增強 & 邊緣檢測
                enhanced_img = enhance_image(img_resized)

                # (3) 檢測旋轉角度 (對 Canny/邊緣圖做檢測)
                angle = detect_rotation_angle(enhanced_img)
                if abs(angle) > 5:
                    img_resized = correct_rotation(img_resized, angle)
                    # 校正後可再次做增強流程
                    enhanced_img = enhance_image(img_resized)

                # (4) OCR：先嘗試對 edge-enhanced 圖做識別
                results = reader.readtext(
                    enhanced_img, 
                    allowlist='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-',
                    detail=1
                )

                # 如果第一次辨識無結果，直接對放大後的「原圖」做一次 OCR
                if not results:
                    logging.info("第一次辨識無結果，對整張圖片進行OCR...")
                    results = reader.readtext(
                        img_resized,
                        allowlist='0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ-',
                        detail=1
                    )

                # (5) 統一提升低於 0.5 的 prob
                best_result = None
                best_confidence = 0.0

                for (bbox, text, prob) in results:
                    # 人為拉高低信心度
                    if prob < 0.5:
                        prob = 0.5

                    corrected = correct_text(text)
                    filtered = filter_plate_text(corrected)
                    if filtered and prob > best_confidence:
                        best_result = filtered
                        best_confidence = prob

                # (6) 在影像上標記最優結果
                logging.info(f"最佳車牌識別結果：{best_result} (信心度: {best_confidence:.2f})")

                for (bbox, text, prob) in results:
                    if prob < 0.5:
                        prob = 0.5
                    if correct_text(text) == best_result:
                        cv2.rectangle(
                            img_resized, 
                            (int(bbox[0][0]), int(bbox[0][1])), 
                            (int(bbox[2][0]), int(bbox[2][1])), 
                            (0, 255, 0), 
                            2
                        )
                        cv2.putText(
                            img_resized, 
                            f"{best_result} ({prob:.2f})", 
                            (int(bbox[0][0]), int(bbox[0][1]) - 10),
                            cv2.FONT_HERSHEY_SIMPLEX, 
                            1, 
                            (0, 255, 0), 
                            2
                        )

                # (7) 輸出結果
                cv2.imwrite(os.path.join(results_dir, f"result_{image_file}"), img_resized)

            except Exception as e:
                logging.error(f"處理 {image_file} 時發生錯誤: {str(e)}")
                continue

        logging.info("處理完成")

    except Exception as e:
        logging.error(f"程式執行錯誤: {str(e)}")

if __name__ == "__main__":
    process_images()
