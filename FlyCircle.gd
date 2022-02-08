extends Spatial

var d = 0
func _process(delta):
	d += delta
	for c in get_children():
		if !c.is_in_group("Plane"):
			continue
		c.rotation_degrees.y += delta * 360 / 30
