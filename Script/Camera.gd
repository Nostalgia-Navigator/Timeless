extends Camera

var shake = preload("res://Effect/Shake.tscn")
export(NodePath) var player
var offset

func _ready():
	player = get_node(player)
	player.connect("on_damaged", self, "shake")
	offset = transform.origin - player.transform.origin
func shake():
	add_child(shake.instance())
func _process(delta):
	var p = player.get_camera_origin() + offset
	transform.origin = Vector3(p.x, transform.origin.y, p.z)
