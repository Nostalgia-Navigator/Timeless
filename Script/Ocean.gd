extends Area3D
var splash = preload("res://Effect/SplashRing.tscn")
var explosion = preload("res://Explosion/Bomb.tscn")

@onready var root = get_parent()
func _on_area_entered(area):
	var n = area.owner
	if n == null: 
		n = area.get_parent()
	var name = n.name
	var container = get_tree().get_root().get_child(0)
	if name == "Bomb":
		var e = explosion.instantiate()
		var p = area.get_global_transform().origin
		e.transform.origin = Vector3(p.x, 0.001, p.z)
		e.emitting = true
		container.call_deferred("add_child", e)
		n.remove()
	elif n.is_in_group("Bullet"):
		var s = splash.instantiate()
		var p = area.get_global_transform().origin
		container.call_deferred("add_child", s)
		s.transform.origin = Vector3(p.x, 0.001, p.z)
		n.queue_free()
func _on_body_entered(body):
	var s = splash.instantiate()
	var p = body.get_global_transform().origin
	s.transform.origin = Vector3(p.x, 0.001, p.z)
	get_tree().get_root().get_child(0).call_deferred("add_child", s)
	body.queue_free()
