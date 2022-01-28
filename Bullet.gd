extends Spatial
export(Vector3) var vel
export(int) var damage = 10
# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass
func _process(delta):
	self.global_translate(vel)
	pass

func _on_area_entered(area):
	var p = area.get_parent()
	if p.is_in_group("Plane"):
		
		p.on_damage(damage)
	self.queue_free()
