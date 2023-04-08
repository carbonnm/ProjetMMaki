from godot import exposed, export
from godot import *

from PIL import Image
import cv2
import matplotlib
import pytesseract

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

@exposed
class WordRecognition(Node):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')

	def _ready(self):
		"""
		Called every time the node is added to the scene.
		Initialization here.
		"""
		pass
	
	def word_recognition(path) :
		im = Image.open(path)
		print(pytesseract.image_to_string(im))
		
		return pytesseract.image_to_string(im)
