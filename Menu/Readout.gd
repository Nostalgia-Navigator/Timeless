extends Control

export(NodePath) var player
var barWidth = 216
func _ready():
	player=get_node(player)
	player.connect("on_damaged", self, "on_player_damaged")
	player.connect("on_respawned", self, "on_player_damaged")
func on_player_damaged(p):
	var hp = max(0, p.hp)
	$Shields.text = "Shields: " + str(int(hp))
	$ShieldsRect.rect_size = Vector2(barWidth * p.hp / 100, 16)
var time = 0
func _process(delta):
	time += delta
	if(time >= 1):
		time = 0
		$Fuel.text = "Fuel: " + str(int(player.fuel))
		$FuelRect.rect_size = Vector2(barWidth * player.fuel / 100, 16)
