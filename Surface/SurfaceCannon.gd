extends Node3D
@export var wreck: PackedScene
const hit = preload("res://Explosion/Hit.tscn")
const explosion = preload("res://Explosion/Bunker.tscn")

signal on_destroyed

func on_outer_hit(area):
	if area.get_parent().is_in_group("Island"):
		return
	var n = area.root
	if n.name == "Tile":
		return
	if n.name == "Bomb":
		var p = area.get_global_transform().origin
		var e = hit.instantiate()
		e.transform.origin = Vector3(p.x, 1, p.z)
		e.emitting = true
		get_parent().add_child(e)
		n.remove()
		$Smoke.emitting = true
func on_inner_hit(area):
	if area.get_parent().is_in_group("Island"):
		return
	var n = area.root
	if n == null: 
		n = area.get_parent()
	if n.name == "Bomb":
		var p = area.get_global_transform().origin
		var e = explosion.instantiate()
		e.transform.origin = Vector3(p.x, 1, p.z)
		e.emitting = true
		get_parent().add_child(e)
		n.remove()
		
		if wreck != null:
			var w = wreck.instantiate()
			w.set_global_transform(get_global_transform())
			get_parent().call_deferred("add_child", w)
		
		var shards = $Destruction.destroy()
		for s in shards.get_children():
			#var offset = (s.get_global_transform().origin - transform.origin)
			var angle = (randf_range(0, PI*2))
			var speed = randf_range(10, 20)
			s.linear_velocity = speed * Vector3(cos(angle), randf_range(0.5, 1), sin(angle))	
			var m = 30
			s.angular_velocity = Vector3(randf_range(-m, m), 0, randf_range(-m, m))
			
			var st = s.get_global_transform()
			s.get_parent().remove_child(s)
			get_parent().call_deferred("add_child", s)
			s.set_global_transform(st)
		emit_signal("on_destroyed", self, n)
		queue_free()

#const charging = preload("res://Surface/Charge.tscn")

@onready var cooldown = randf_range(6, 12)
func _process(delta):
	cooldown -= delta
	if cooldown <= 0:
		cooldown = 6
		fire()
		
@export var turretNode: NodePath
@export var turretBias: float
@onready var turret = get_node(turretNode)
func _physics_process(delta):
	var player = $Wraparound.player
	var from = get_global_transform().origin
	var to = player.get_global_transform().origin
	var angle = atan2(to.z - from.z, to.x - from.x)
	turret.rotation.y = turretBias - angle 
@export var shot: PackedScene
const radius2 = 80*80
func fire():
	if shot == null:
		return
	var player = $Wraparound.player
	var tr = get_global_transform()
	
	var from = tr.origin
	var to = player.get_global_transform().origin
	
	from = Vector3(from.x, to.y, from.z)
	var offset = to - from
	if offset.length_squared() < radius2:
		var s = shot.instantiate()
		get_parent().add_child(s)
		
		#tr.origin = from
		s.set_global_transform(tr)
		s.rotation.y = atan2(offset.x, offset.z)
