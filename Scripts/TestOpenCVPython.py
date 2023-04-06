from godot import exposed, export
from godot import *

from PIL import image
import cv2
import matplotlib
import pytesseract


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
		pass
