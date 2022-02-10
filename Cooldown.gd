extends Node

var cooldown_timer
var fire_timer
func _ready():
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.wait_time = 6
	cooldown_timer.connect("timeout", self, "fire")
	
	fire_timer = Timer.new()
	add_child(fire_timer)
	fire_timer.wait_time = 1
	fire_timer.connect("timeout", self, "fire")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
