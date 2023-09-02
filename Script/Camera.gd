extends Camera3D
var shake = preload("res://Effect/Shake.tscn")
@export var player: NodePath
var offset
func _ready():
	player = get_node(player)
	player.connect("on_damaged", Callable(self, "shake"))
	offset = transform.origin - player.transform.origin
func shake(p):
	add_child(shake.instantiate())
func _process(delta):
	var p = player.get_camera_origin() + offset
	transform.origin = Vector3(p.x, transform.origin.y, p.z)
