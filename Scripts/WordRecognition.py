from PIL import Image
import pytesseract

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

pathImage = "ScreenShots/screenshot.png"

im = Image.open(pathImage)

jpg_im = im.convert("RGB")

print(pytesseract.image_to_string(jpg_im))
