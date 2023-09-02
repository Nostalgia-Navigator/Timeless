extends Node

@export var cooldown: float
@export var fireCheckInterval: float 

func set_time(cooldown, fireCheckInterval):
	$Cooldown.wait_time = cooldown
	$Fire.wait_time = fireCheckInterval

signal check_fire
func _ready():
	set_time(cooldown, fireCheckInterval)
	
	$Cooldown.start()
func check_fire():
	$Cooldown.stop()
	$Fire.start()
	emit_signal("check_fire", self)
func on_fired():
	$Cooldown.start()
	$Fire.stop()
	
func stop():
	$Cooldown.stop()
	$Fire.stop()
func start():
	$Cooldown.start()
