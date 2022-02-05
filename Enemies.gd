extends Node

export(PackedScene) var boss = preload("res://BleriotXIMonoplaneCyan.tscn")
var count = 0
func _ready():
	var leaves = getLeaves(self)
	count = len(leaves)
	for c in leaves:
		var n = c.name
		print(c.name)
		c.connect("on_destroyed", self, "check_boss")
func check_boss():
	count -= 1
	if count == 0:
		var b = boss.instance()
		b.connect("on_destroyed", self, "on_boss_destroyed")
		get_parent().add_child(b)
		pass
func on_boss_destroyed():
	
	pass
func getLeaves(n):
	if n.is_in_group("Plane"):
		return [n]
	var a = []
	for c in n.get_children():
		a.append_array(getLeaves(c))
	return a
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
