extends Spatial
export(int) var damage = 4
func _on_area_entered(area):
	var p = area.get_parent()
	if p.is_in_group("Player"):
		if (p.playing and p.vulnerable):
			p.on_damage(self)
			self.queue_free()
