extends Node
export(PackedScene) var scene
export(bool) var fade = false
onready var ap = get_parent().get_node("AnimationPlayer")
func clicked():
	if fade:
		ap.play("Exit")
		ap.connect("animation_finished", self, "transition")
		return
	
	get_tree().change_scene_to(scene)	
func transition(anim):
	ap.disconnect("animation_finished", self, "transition")
	get_tree().change_scene_to(scene)	
