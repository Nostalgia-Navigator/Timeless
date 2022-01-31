extends Camera

var shake = preload("res://Shake.tscn")
export(NodePath) var player
var offset

func _ready():
	player = get_node(player)
	player.connect("on_damaged", self, "shake")
	offset = self.transform.origin - player.transform.origin
	pass # Replace with function body.
func shake():
	add_child(shake.instance())
func _process(delta):
	var p = player.transform.origin + offset
	self.transform.origin = Vector3(p.x, transform.origin.y, p.z)
