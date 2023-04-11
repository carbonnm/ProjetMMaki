from PIL import Image
import cv2
import matplotlib
import pytesseract

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'
#print("hehe")

pathImage = "ScreenShots/screenshot.png"
im = Image.open(pathImage)
#image = cv2.imread(r'testPythonOpenCV.png')
print(pytesseract.image_to_string(im))
