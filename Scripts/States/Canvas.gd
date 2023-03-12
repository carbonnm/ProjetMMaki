class_name Canvas
extends Node

# Delegate state management to the state manager
onready var states = $StateManager


"""
Function called automatically when the node is ready for use. It performs
its initialization and configuration when the node is loaded.
"""
func _ready() -> void:
	states.init(self)

"""
Function called when an input event is not consumed by any other node in the
scene. It handle input events that are not handled by other nodes.

Parameters:
-----------
event: The input event that was not handled by any other node in the scene.
(InputEvent)
"""
func _unhandled_input(event: InputEvent) -> void:
	states.input(event)

"""
Function called every physics frame (every time the physics engine update). It
applies physics-based logic to a node.

Parameters:
-----------
delta: The time elapsed since the last physics frame, in seconds. (float)
"""
func _physics_process(delta: float) -> void:
	states.physics_process(delta)



