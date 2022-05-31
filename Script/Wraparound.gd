extends Timer

class_name Wraparound

const EXTENT = 240
var player
signal on_wrapped
func _ready():
	player = get_tree().get_root().get_node("Main/Player")
func wrap():
	var t = get_parent().get_global_transform()
	var o = t.origin
	var dx = o.x - player.get_global_transform().origin.x
	var delta = Vector3(0, 0, 0)
	if dx < -EXTENT:
		delta.x += 2 * EXTENT
	elif dx > EXTENT:
		o.x -= 2 * EXTENT
		delta.x -= 2 * EXTENT
	var dz = o.z - player.get_global_transform().origin.z
	if dz < -EXTENT:
		o.z += 2 * EXTENT
		delta.z += 2 * EXTENT
	elif dz > EXTENT:
		o.z -= 2 * EXTENT
		delta.z -= 2 * EXTENT
	if delta.length() == 0:
		return
	get_parent().global_translate(delta)
	emit_signal("on_wrapped", delta)
