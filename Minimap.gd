extends MarginContainer

export (NodePath) var player
onready var grid = $MarginContainer/Grid
onready var player_marker = $MarginContainer/Grid/Player
onready var goodie_marker = $MarginContainer/Grid/Goodie
onready var l1_marker = $MarginContainer/Grid/Green
onready var l2_marker = $MarginContainer/Grid/Yellow
onready var l3_marker = $MarginContainer/Grid/Orange
onready var planeMarkers = [l1_marker, l2_marker, l3_marker]

var grid_scale
var markers = {}

func _ready():
	player = get_node(player)
	player_marker.position = grid.rect_size / 2
	grid_scale = grid.rect_size / (300 * 2)
	for enemy in get_tree().get_nodes_in_group("Plane"):
		enemy.connect("on_destroyed", self, "remove_marker")
		var i = enemy.markerType
		var n = enemy.name
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
func remove_marker(e):
	grid.remove_child(markers[e])
	markers.erase(e)
func _process(delta):
	if !player:
		return
	player_marker.rotation = player.rotation.y + PI/2
	for enemy in markers:
		var o = enemy.get_global_transform().origin - player.transform.origin
		o = Vector2(o.x, o.z)
		var p = o * grid_scale + grid.rect_size / 2
		
		p.x = clamp(p.x, 0, grid.rect_size.x)
		p.y = clamp(p.y, 0, grid.rect_size.y)
		markers[enemy].position = p
