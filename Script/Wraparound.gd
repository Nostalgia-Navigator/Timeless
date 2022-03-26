extends Timer
const size = 288
var player
signal on_wrapped
func _ready():
	player = get_tree().get_root().get_node("Main/Player")
func wrap():
	var t = get_parent().get_global_transform()
	var o = t.origin
	var dx = o.x - player.transform.origin.x
	var delta = Vector3(0, 0, 0)
	if dx < -size:
		delta.x += 2 * size
	elif dx > size:
		o.x -= 2 * size
		delta.x -= 2 * size
	var dz = o.z - player.transform.origin.z
	if dz < -size:
		o.z += 2 * size
		delta.z += 2 * size
	elif dz > size:
		o.z -= 2 * size
		delta.z -= 2 * size
	if delta.length() == 0:
		return
	get_parent().global_translate(delta)
	emit_signal("on_wrapped", delta)
