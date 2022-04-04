extends Node
export(NodePath) var root
func _ready():
	root = get_node(root)
