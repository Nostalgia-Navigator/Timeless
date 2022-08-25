extends Node
export(PackedScene) var scene
export(bool) var fade = false
export(NodePath) var anim
const transition = preload("res://Sounds/Menu/Transition - snd .1037.dat.wav")



func _ready():
	anim = get_node(anim)
func clicked():
	if fade:
		Game.play_sound(transition, Game.Sounds.Menu)
		anim.play("Exit")
		anim.connect("animation_finished", self, "transition")
		#Thread.new().start(self, "instance_scene")
	else:
		get_tree().change_scene_to(scene)	
func instance_scene():
	scene.instance()
func transition(a):
	anim.disconnect("animation_finished", self, "transition")
	get_tree().change_scene_to(scene)	
