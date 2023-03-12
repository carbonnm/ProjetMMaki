extends IState

export (NodePath) var rescale_node

onready var rescale: IState = get_node(rescale_node)


func input(event: InputEvent) -> IState:
	return null

func physics_process(delta: float) -> IState:
	return null







