extends IState

export (NodePath) var dragAndDrop_node

onready var drag_and_drop: IState = get_node(dragAndDrop_node)


func input(event: InputEvent) -> IState:
	return null

func physics_process(delta: float) -> IState:
	return null







