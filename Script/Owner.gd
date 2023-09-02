extends Node
@export var root: NodePath
func _ready():
	root = get_node(root)
