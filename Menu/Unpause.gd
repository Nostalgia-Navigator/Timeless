extends Node
export(bool) var fade = false
export(NodePath) var anim
func _ready():
	anim = get_node(anim)
func clicked():
	if fade:
		anim.play("Exit")
		anim.connect("animation_finished", self, "transition")
		return
	
	go()
func transition(a):
	anim.disconnect("animation_finished", self, "transition")
	go()
func go():
	var paused = Game.paused
	var root = get_tree().root
	root.remove_child(root.get_child(root.get_child_count() - 1))
	root.add_child(paused)
	Game.paused = null
