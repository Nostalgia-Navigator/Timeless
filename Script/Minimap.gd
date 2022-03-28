extends MarginContainer

onready var grid = $MarginContainer/Grid
onready var player_marker = $MarginContainer/Grid/Player
onready var goodie_marker = $MarginContainer/Grid/Goodie
onready var l1_marker = $MarginContainer/Grid/Green
onready var l2_marker = $MarginContainer/Grid/Yellow
onready var l3_marker = $MarginContainer/Grid/Orange
onready var carrier_marker = $MarginContainer/Grid/Carrier
onready var boss_marker = $MarginContainer/Grid/Boss
onready var planeMarkers = [l1_marker, l2_marker, l3_marker]

export (NodePath) var player
var carrier
var boss

var grid_scale
var markers = {}

const Wraparound = preload("res://Script/Wraparound.gd")

# TO DO: boss plane, carrier outro
func _ready():
	call_deferred("register_markers")
func register_markers():
	player = get_node(player)
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (Wraparound.EXTENT * 2)
	
	carrier = player.get_parent().get_node("Carrier")
	var m = carrier_marker.duplicate()
	grid.add_child(m)
	m.show()
	markers[carrier] = m
	carrier.connect("tree_exited", self, "remove_carrier")
	
	var enemies = player.get_parent().get_node("Enemies")
	enemies.connect("on_boss_spawned", self, "register_boss")
	
	for enemy in get_tree().get_nodes_in_group("Plane"):
		enemy.connect("on_destroyed", self, "remove_marker")
		var i = enemy.markerType
		#var n = enemy.name
		var new_marker = planeMarkers[i].duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[enemy] = new_marker
	for goodie in get_tree().get_nodes_in_group("Goodie"):
		goodie = goodie.get_parent().get_parent().get_parent().get_parent()
		goodie.connect("on_removed", self, "remove_marker")
		var new_marker = goodie_marker.duplicate()
		grid.add_child(new_marker)
		new_marker.show()
		markers[goodie] = new_marker
func register_boss(boss):
	boss.connect("on_destroyed", self, "remove_marker")
	boss.connect("on_destroyed", self, "add_landing")
	var new_marker = boss_marker.duplicate()
	grid.add_child(new_marker)
	new_marker.show()
	markers[boss] = new_marker
func add_landing(boss, projectile):
	call_deferred("add_landing_deferred")
func add_landing_deferred():
	carrier = player.get_parent().get_node("Landing/Carrier")
	var m = carrier_marker.duplicate()
	grid.add_child(m)
	m.show()
	markers[carrier] = m
	
	
func remove_carrier():
	grid.remove_child(markers[carrier])
	markers.erase(carrier)
func remove_marker(e, projectile):
	
	if markers.has(e):
		grid.remove_child(markers[e])
		markers.erase(e)
func _process(delta):
	if !player:
		return
	#player_marker.rotation = player.rotation.y + PI/2
	for enemy in markers:
		var o = enemy.get_global_transform().origin - player.transform.origin
		o = Vector2(o.x, o.z)
		var p = o * grid_scale + grid.rect_size / 2
		while p.x > grid.rect_size.x:
			p.x -= grid.rect_size.x
		while p.x < 0:
			p.x += grid.rect_size.x
			
		while p.y > grid.rect_size.y:
			p.y -= grid.rect_size.y
		while p.y < 0:
			p.y += grid.rect_size.y
			
		markers[enemy].position = p
