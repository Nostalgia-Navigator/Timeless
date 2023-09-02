extends Node3D
signal on_removed
func remove():
	if !is_inside_tree():
		return
	emit_signal("on_removed", self)
	queue_free()
