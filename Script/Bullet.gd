extends Spatial
export(Vector3) var vel
export(int) var damage = rand_range(4, 16)
export(String, "Plane", "Player") var hit = "Plane"
var source

signal on_hit

func _physics_process(delta):
	self.global_translate(vel * delta)
func _on_area_entered(area):
	var p = area.get_parent()
	if p.is_in_group(hit):
		if (p.playing and p.vulnerable if hit == "Player" else true):
			p.on_damage(self)
			emit_signal("on_hit", self, p)
			queue_free()
			return
	if hit == "Plane":
		if area.is_in_group("Goodie"):
			p = area.get_parent().get_parent().get_parent().get_parent()
			p.damage(self)
			emit_signal("on_hit", self, p)
			queue_free()
