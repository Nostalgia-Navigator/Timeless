extends MarginContainer

onready var grid = $MarginContainer/Grid
onready var player_marker = $MarginContainer/Grid/Player
onready var goodie_marker = $MarginContainer/Grid/Goodie
onready var cyan = $MarginContainer/Grid/Cyan
onready var green = $MarginContainer/Grid/Green
onready var yellow = $MarginContainer/Grid/Yellow
onready var orange = $MarginContainer/Grid/Orange
onready var red = $MarginContainer/Grid/Red
onready var carrier_marker = $MarginContainer/Grid/Carrier
onready var boss_marker = $MarginContainer/Grid/Boss
onready var planeMarkers = [green, yellow, orange]
onready var surface_marker = red

export (NodePath) var player
var carrier
var boss

var grid_scale
var markers = {}

const Wraparound = preload("res://Script/Wraparound.gd")

# TO DO: boss plane, carrier outro
func _ready():
	call_deferred("register_markers")
	
func register_island():
	for island in get_tree().get_nodes_in_group("Island"):
		var s = Sprite.new()
		s.scale = s.scale / 2
		s.texture = island.texture
		markers[island] = s
		grid.add_child(s)
		s.z_index = 0
	
func register_markers():
	player = get_node(player)
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (Wraparound.EXTENT * 2)
	
	
	if true:
		carrier = player.get_parent().get_node("Carrier")
		var m = carrier_marker.duplicate()
		grid.add_child(m)
		m.show()
		markers[carrier] = m
		carrier.connect("tree_exited", self, "remove_carrier")
	
	call_deferred("register_island")
	
	for goodie in get_tree().get_nodes_in_group("Goodie"):
		if goodie is Area:
			continue
		goodie.connect("on_removed", self, "remove_marker")
		
		var m = goodie_marker.duplicate()
		grid.add_child(m)
		m.show()
		markers[goodie] = m
		
	for surface in get_tree().get_nodes_in_group("Surface"):
		surface.connect("on_destroyed", self, "remove_marker")
		
		var m = surface_marker.duplicate()
		grid.add_child(m)
		m.show()
		markers[surface] = m
	
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
		if goodie is Area:
			continue
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
	if carrier in markers:
		grid.remove_child(markers[carrier])
		markers.erase(carrier)
func remove_marker(e, projectile):
	
	if markers.has(e):
		grid.remove_child(markers[e])
		markers.erase(e)
func _process(delta):
	if !player:
		return
		
	var center = grid.rect_size / 2
	#player_marker.rotation = player.rotation.y + PI/2
	for enemy in markers:
		var o = enemy.get_global_transform().origin - player.transform.origin
		var p = Vector2(o.x, o.z) * grid_scale + center
		while p.x > grid.rect_size.x:
			p.x -= grid.rect_size.x
		while p.x < 0:
			p.x += grid.rect_size.x
			
		while p.y > grid.rect_size.y:
			p.y -= grid.rect_size.y
		while p.y < 0:
			p.y += grid.rect_size.y
			
		var m = markers[enemy]
		m.position = p
		m.rotation_degrees = PI - enemy.rotation_degrees.y
