extends Area
var splash = preload("res://Effect/SplashRing.tscn")
var explosion = preload("res://Explosion/Bomb.tscn")

onready var root = get_parent()
func _on_area_entered(area):
	var n = area.owner
	if n == null: 
		n = area.get_parent()
	if n.name == "Bomb":
		var e = explosion.instance()
		var p = area.get_global_transform().origin
		e.transform.origin = Vector3(p.x, 0.001, p.z)
		e.emitting = true
		get_tree().get_root().get_child(0).add_child(e)
		n.queue_free()
	elif n.name == "SpikeBullet":
		var s = splash.instance()
		var p = area.get_global_transform().origin
		get_tree().get_root().get_child(0).add_child(s)
		s.transform.origin = Vector3(p.x, 0.001, p.z)
		n.queue_free()
func _on_body_entered(body):
	var s = splash.instance()
	var p = body.get_global_transform().origin
	s.transform.origin = Vector3(p.x, 0.001, p.z)
	get_tree().get_root().get_child(0).add_child(s)
	body.queue_free()
