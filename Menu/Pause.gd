extends Control
var prev
func _process(delta):
	var pressed = Input.is_key_pressed(KEY_ESCAPE)
	if pressed and !prev:
		if visible:
			unpause()
		else:
			show()
			get_tree().paused = true
	prev = pressed
func unpause():
	hide()
	get_tree().paused = false
func quit():
	get_tree().change_scene("res://Menu/Title.tscn")
