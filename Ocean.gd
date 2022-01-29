extends Area
var splash = preload("res://SplashRing.tscn")
func _ready():
	pass
func _on_body_entered(body):
	var s = splash.instance()
	var p = body.get_global_transform().origin
	s.transform.origin = Vector3(p.x, 1, p.z)
	get_tree().get_root().get_child(0).add_child(s)
	body.queue_free()
	pass # Replace with function body.
