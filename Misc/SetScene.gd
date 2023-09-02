extends Node
@export var scene: PackedScene
@export var fade: bool = false
@export var anim: NodePath
const transition = preload("res://Sounds/Menu/Transition - snd .1037.dat.wav")



func _ready():
	anim = get_node(anim)
func clicked():
	if fade:
		Game.play_sound(transition, Game.Sounds.Menu)
		anim.play("Exit")
		anim.connect("animation_finished", Callable(self, "transition"))
		#Thread.new().start(self, "instance_scene")
	else:
		get_tree().change_scene_to_packed(scene)	
func instance_scene():
	scene.instantiate()
func transition(a):
	anim.disconnect("animation_finished", Callable(self, "transition"))
	get_tree().change_scene_to_packed(scene)	
