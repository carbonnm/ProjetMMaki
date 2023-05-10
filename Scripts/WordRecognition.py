from PIL import Image
import pytesseract

pathImage = "ScreenShots/screenshot.png"

im = Image.open(pathImage).convert('L')

width, height = im.size

im = im.resize((width*5, height*5))

text = pytesseract.image_to_string(im).replace("\n", " ").strip()

print(text, end="")
