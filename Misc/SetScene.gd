extends Node
export(PackedScene) var scene
export(bool) var fade = false
export(NodePath) var anim
func _ready():
	anim = get_node(anim)
func clicked():
	if fade:
		anim.play("Exit")
		anim.connect("animation_finished", self, "transition")
		return
	
	get_tree().change_scene_to(scene)	
func transition(a):
	anim.disconnect("animation_finished", self, "transition")
	get_tree().change_scene_to(scene)	
