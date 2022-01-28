extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var splash = preload("res://SplashRing.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_body_entered(body):
	var s = splash.instance()
	s.transform.origin = body.get_global_transform().origin + Vector3(0, 0.5, 0)
	s.get_node("AnimationPlayer").play("default")
	get_tree().get_root().get_child(0).add_child(s)
	body.queue_free()
	pass # Replace with function body.
