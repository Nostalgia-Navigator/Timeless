extends Camera

export(NodePath) var player
var offset

func _ready():
	player = get_node(player)
	offset = self.transform.origin - player.transform.origin
	pass # Replace with function body.
func _process(delta):
	self.transform.origin = player.transform.origin + offset
