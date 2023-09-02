extends Node3D
var vel
func _ready():
	var angle = randf() * PI * 2
	var speed = 2.0 / 15
	vel = Vector3(speed*cos(angle), 0, speed*sin(angle))
func _process(delta):
	transform.origin += vel
