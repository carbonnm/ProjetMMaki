from godot import exposed, export, Node2D, Sprite, ColorRect
from godot import *

from PIL import Image
import cv2
import matplotlib
import pytesseract

pytesseract.pytesseract.tesseract_cmd = r'C:\Program Files\Tesseract-OCR\tesseract.exe'

@exposed
class TestOpenCVPython(Node2D):

	# member variables here, example:
	a = export(int)
	b = export(str, default='foo')

	def _ready(self):
		"""
		Called every time the node is added to the scene.
		Initialization here.
		"""
		pathImage = 'TestPython/testPythonOpenCV.png'
		im = Image.open(pathImage)
		#image = cv2.imread(r'testPythonOpenCV.png')
		print(pytesseract.image_to_string(im))
