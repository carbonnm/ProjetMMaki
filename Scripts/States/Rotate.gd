extends IState

export (NodePath) var rotate_node

onready var rotate: IState = get_node(rotate_node)


func input(event: InputEvent) -> IState:
	return null

func physics_process(delta: float) -> IState:
	return null









