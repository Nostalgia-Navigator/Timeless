extends Spatial

export(int, 0, 2, 1) var markerType
export(int) var hp = 15
export(float) var speed = 0.4
export(Material) var material
var smoke
const timer = preload("res://ParticleTimer.tscn")
const explosion = preload("res://Explosion.tscn")
const debris = preload("res://Debris.tscn")
const bullet = preload("res://SmallBullet.tscn")
signal on_destroyed

const fireCooldown = 5
var cooldownLeft = fireCooldown

var d = 0
func _ready():
	smoke = $Smoke
	$Area.connect("area_entered", self, "on_area_entered")
func on_area_entered(other):
	var p = other.get_parent()
	if p.is_in_group("Player"):
		p.on_damage(10)
func _process(delta):
	d += delta
	rotation_degrees.y += sin(d * (PI * 2) / 8) * 3 / 15
	
	# use global coordinates, not local to node
	var firing = false
	var player = $Wraparound.player
	var p = player.get_camera_origin()
	if cooldownLeft <= delta and player.is_inside_tree():
		var offset = p - get_global_transform().origin
		var distance = offset.length()
		var vel = -get_global_transform().basis.z * speed
		var playerVel = -player.get_global_transform().basis.z * player.speed
		var velDiff = playerVel - vel
		var bulletSpeed = 1.5
		
		
		
		#var future_offset = offset + velDiff * distance / (bulletSpeed * 60)
		if distance < 80:
			var result = get_world().direct_space_state.intersect_ray(transform.origin, player.transform.origin, [$Area], 2147483647, false, true)
			var clear = result.empty() or (result["collider"].get_parent() == player)
			
			if clear:
				var b = bullet.instance()
				
				get_parent().add_child(b)
				b.set_global_transform(get_global_transform())
				b.vel = 1.2 * offset.normalized() + vel
				
				cooldownLeft = fireCooldown
				firing = true
		if !firing:
			cooldownLeft = 0.5
	else:
		cooldownLeft -= delta
		
	self.translate(Vector3(0, 0, -speed))
func on_damage(projectile):
	var damage = projectile.damage
	hp -= damage
	if(hp <= 0):
		smoke.emitting = false
		var p = smoke.get_parent()
		p.remove_child(smoke)
		
		var t = timer.instance()
		t.time = 5
		t.transform.origin = smoke.get_global_transform().origin
		t.call_deferred("add_child", smoke)
		
		get_parent().call_deferred("add_child", t)
		queue_free()
		
		var e = explosion.instance()
		e.emitting = true
		e.process_material.set("initial_velocity", -speed * 60 * 1.25)
		get_parent().add_child(e)
		e.set_global_transform(get_global_transform())
		
		var vel = -get_global_transform().basis.z * speed * 15
		var shards = $Destruction.destroy()
		for s in shards.get_children():
			var angle = rand_range(0, PI*2)
			var speed = rand_range(1, 5)
			s.linear_velocity = vel + Vector3(speed * cos(angle), 0, speed * sin(angle))	
			var m = 90
			s.angular_velocity = Vector3(rand_range(-m, m), rand_range(-m, m), rand_range(-m, m))
			
		emit_signal("on_destroyed", self)
	else:
		var vel = -get_global_transform().basis.z * speed * 15
		var d = debris.instance()
		get_parent().add_child(d)
		d.get_node("Body").set_surface_material(0, material)
		d.set_global_transform(projectile.get_global_transform())
		var angle = randf() * PI * 2
		d.linear_velocity = vel + projectile.vel.normalized() * 2 + 2 * Vector3(cos(angle), 0, sin(angle))
		var m = 90
		d.angular_velocity = Vector3(rand_range(-m, m), rand_range(-m, m), rand_range(-m, m))
		
		if hp <= 10:
			smoke.emitting = true
			smoke.process_material.set("initial_velocity", -speed * 60)
		pass
