extends Spatial

enum GoodieType {STAR, TIME, CREWMATE, SHIELDS, WEAPON, BOMB, FUEL}
export(GoodieType) var goodie
export(Material) var color1
export(Material) var color2


const wraparound = 288
var player
var d=0
func _ready():
	player = get_tree().get_root().get_node("Main/Player")
func _process(delta):
	d += delta
	if d > 1:
		var dx = transform.origin.x - player.transform.origin.x
		if dx < -wraparound:
			transform.origin.x += 2 * wraparound
		elif dx > wraparound:
			transform.origin.x -= 2 * wraparound
		var dz = transform.origin.z - player.transform.origin.z
		if dz < -wraparound:
			transform.origin.z += 2 * wraparound
		elif dz > wraparound:
			transform.origin.z -= 2 * wraparound
		d = 0
