extends Particles

export(PoolColorArray) var colors
var _colors = [Color("bb00ff"), Color("0034ff"), Color("00ff8d")]

# Called when the node enters the scene tree for the first time.
func _ready():
	process_material.color = _colors[randi()%len(_colors)]
