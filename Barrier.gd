extends Sprite3D
func _process(delta):
	transform.origin = get_parent().get_parent().get_global_transform().origin
