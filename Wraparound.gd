extends Spatial
const wraparound = 288
var player
var d=0
func _ready():
	player = get_tree().get_root().get_node("Main/Player")
func wrap():
	var t = get_parent().transform
	var dx = t.origin.x - player.transform.origin.x
	if dx < -wraparound:
		t.origin.x += 2 * wraparound
	elif dx > wraparound:
		t.origin.x -= 2 * wraparound
	var dz = t.origin.z - player.transform.origin.z
	if dz < -wraparound:
		t.origin.z += 2 * wraparound
	elif dz > wraparound:
		t.origin.z -= 2 * wraparound
