extends Spatial

export(Vector3) var vel
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	self.global_translate(Vector3(19, 0, 0))
	pass
