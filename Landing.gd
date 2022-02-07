extends Spatial
func _on_area_entered(area):
	var n = area.get_parent()
	
	if n.is_in_group("Player") and n.playing:
		n.playing = false
		var p = n.get_parent()
		p.remove_child(n)
		$PlayerHolder.add_child(n)
		
		#var pos = n.get_global_transform().origin
		#var pos2 = $PlayerHolder.get_global_transform().origin
		#n.transform.origin = pos2
		n.rotation = Vector3(0, PI, 0)
		n.get_node("Body").rotation = Vector3(0, 0, 0)
		n.transform.origin = Vector3(0, 0, 0)
		n.exhaust.emitting = false
		n.get_node("AnimationPlayer").play("RESET")
		$Animation.play("Landing")
