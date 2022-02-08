extends Timer
const wraparound = 288
var player
var d=0
func _ready():
	player = get_tree().get_root().get_node("Main/Player")
func wrap():
	var t = get_parent().get_global_transform()
	var o = t.origin
	var dx = o.x - player.transform.origin.x
	if dx < -wraparound:
		o.x += 2 * wraparound
	elif dx > wraparound:
		o.x -= 2 * wraparound
	var dz = o.z - player.transform.origin.z
	if dz < -wraparound:
		o.z += 2 * wraparound
	elif dz > wraparound:
		o.z -= 2 * wraparound
	t.origin = o
	get_parent().set_global_transform(t)
