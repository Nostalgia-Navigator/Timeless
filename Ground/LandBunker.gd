extends Spatial
const hit = preload("res://Explosion/Hit.tscn")
const explosion = preload("res://Explosion/Bunker.tscn")

func _ready():
	pass
func on_outer_hit(area):
	var n = area.root
	if n.name == "Tile":
		return
	if n.name == "Bomb":
		var p = area.get_global_transform().origin
		var e = hit.instance()
		e.transform.origin = Vector3(p.x, 1, p.z)
		e.emitting = true
		get_parent().add_child(e)
		n.queue_free()
		$Smoke.emitting = true
func on_inner_hit(area):
	var n = area.root
	if n == null: 
		n = area.get_parent()
	if n.name == "Bomb":
		var p = area.get_global_transform().origin
		var e = explosion.instance()
		e.transform.origin = Vector3(p.x, 1, p.z)
		e.emitting = true
		get_parent().add_child(e)
		n.queue_free()
		
		var shards = $Destruction.destroy()
		for s in shards.get_children():
			#var offset = (s.get_global_transform().origin - transform.origin)
			var angle = (rand_range(0, PI*2))
			var speed = rand_range(10, 20)
			s.linear_velocity = speed * Vector3(cos(angle), rand_range(0.5, 1), sin(angle))	
			var m = 30
			s.angular_velocity = Vector3(rand_range(-m, m), 0, rand_range(-m, m))
			
			var st = s.get_global_transform()
			s.get_parent().remove_child(s)
			get_parent().add_child(s)
			s.set_global_transform(st)
		queue_free()
