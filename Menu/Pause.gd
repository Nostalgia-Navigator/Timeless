extends Control
var prev
func _process(delta):
	var pressed = Input.is_key_pressed(KEY_ESCAPE)
	if pressed and !prev:
		prev = pressed
		if visible:
			unpause()
		else:
			get_tree().paused = true
			$AnimationPlayer.play("Enter")
			show()
			await $AnimationPlayer.animation_finished
	else:
		prev = pressed
func unpause():
	$AnimationPlayer.play("Exit")
	await $AnimationPlayer.animation_finished
	hide()
	get_tree().paused = false
func quit():
	$AnimationPlayer.play("Exit")
	await $AnimationPlayer.animation_finished
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Menu/Title.tscn")
