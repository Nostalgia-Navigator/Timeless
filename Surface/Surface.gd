extends Spatial
export(PackedScene) var wreck
const hit = preload("res://Explosion/Hit.tscn")
const explosion = preload("res://Explosion/Bunker.tscn")

var hp = 1

signal on_destroyed

func on_outer_hit(area):
	if area.get_parent().is_in_group("Island"):
		return
	var n = area.root
	if n.name == "Tile":
		return
	if n.name == "Bomb":
		var p = area.get_global_transform().origin
		var e = hit.instance()
		e.transform.origin = Vector3(p.x, 1, p.z)
		e.emitting = true
		get_parent().call_deferred("add_child", e)
		n.remove()
		$Smoke.emitting = true
		
		hp -= 1
		if hp < 1:
			destroy(n)
func on_inner_hit(area):
	if area.get_parent().is_in_group("Island"):
		return
	var n = area.root
	if n == null: 
		n = area.get_parent()
	if n.name == "Bomb":
		var p = area.get_global_transform().origin
		var e = explosion.instance()
		e.transform.origin = Vector3(p.x, 1, p.z)
		e.emitting = true
		get_parent().call_deferred("add_child", e)
		n.remove()
		
		hp -= 2
		if hp < 1:
			destroy(n)
	

func destroy(bomb):
	
	if wreck != null:
		var w = wreck.instance()
		w.set_global_transform(get_global_transform())
		get_parent().call_deferred("add_child", w)
	
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
		get_parent().call_deferred("add_child", s)
		s.set_global_transform(st)
	emit_signal("on_destroyed", self, bomb)
	queue_free()

const charging = preload("res://Surface/Charge.tscn")

onready var cooldown = rand_range(6, 12)
func _process(delta):
	cooldown -= delta
	if cooldown <= 0:
		cooldown = 6
		charge()
func charge():
	var c = charging.instance()
	add_child(c)
	c.transform.origin = Vector3(0, 0.1, 0)
	c.get_node("AnimationPlayer").connect("animation_finished", self, "fire")
export(PackedScene) var shot
export(int) var radius = 80
export(float) var bias = 0
func fire(anim):
	if shot == null:
		return
	var player = $Wraparound.player
	var tr = get_global_transform()
	
	var from = tr.origin
	var to = player.get_global_transform().origin
	
	from = Vector3(from.x, to.y, from.z)
	var offset = to - from
	if offset.length_squared() < radius * radius:
		var s = shot.instance()
		get_parent().add_child(s)
		
		#tr.origin = from
		s.set_global_transform(tr)
		s.rotation.y = bias + atan2(offset.x, offset.z)
