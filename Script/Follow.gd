extends Node3D

@export var player: NodePath
var offset

func _ready():
	player = get_node(player)
	offset = self.transform.origin - player.transform.origin
func _process(delta):
	self.transform.origin = player.transform.origin + offset
