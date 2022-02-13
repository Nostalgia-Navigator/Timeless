extends Node

export(PackedScene) var boss = preload("res://Plane/BleriotXIMonoplaneCyan.tscn")
const outro = preload("res://Landing.tscn")
var count = 0
var player

signal on_boss_spawned
func _ready():
	player = get_tree().get_root().get_node("Main/Player")
	call_deferred("register_planes")
func register_planes():
	var leaves = getLeaves(self)
	count = len(leaves)
	for c in leaves:
		var n = c.name
		print(c.name)
		c.connect("on_destroyed", self, "check_boss")
func check_boss(e, projectile):
	count -= 1
	if count <= 0:
		var b = boss.instance()
		var angle = randf() * PI * 2
		var distance = 300
		b.transform.origin = player.get_global_transform().origin + Vector3(distance*cos(angle), 0, distance*sin(angle))
		b.connect("on_destroyed", self, "on_boss_destroyed")
		get_parent().add_child(b)
		emit_signal("on_boss_spawned", b)
func on_boss_destroyed(boss, projectile):
	var o = outro.instance()
	var angle = randf() * PI * 2
	var distance = 100
	var p = player.get_global_transform().origin
	p = Vector3(p.x, 24, p.y)
	o.transform.origin = p + Vector3(distance*cos(angle), 0, distance*sin(angle))
	get_parent().add_child(o)
	pass
func getLeaves(n):
	var a = []
	if n.is_in_group("Plane"):
		a.append(n)
	var ch = n.get_children()
	for c in ch:
		var l = getLeaves(c)
		a.append_array(l)
	return a
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
