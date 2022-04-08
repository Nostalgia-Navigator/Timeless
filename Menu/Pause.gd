extends Control

func _process(delta):
	if Input.is_key_pressed(KEY_ESCAPE):
		if visible:
			unpause()
		else:
			show()
			$AnimationPlayer.play("Enter")
			get_tree().paused = true
func unpause():
	hide()
	get_tree().paused = false
