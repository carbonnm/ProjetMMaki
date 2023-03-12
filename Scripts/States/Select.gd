extends IState

export (NodePath) var select_node

onready var select: IState = get_node(select_node)


func input(event: InputEvent) -> IState:
	return null

func physics_process(delta: float) -> IState:
	return null





