extends Spatial

var speed = 0.6
func _ready():
	pass # Replace with function body.
func _process(delta):
	self.translate(Vector3(0, 0, -speed))
