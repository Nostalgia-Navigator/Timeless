extends Spatial


export(int, 0, 2, 1) var markerType
export(int) var hp = 15
export(float) var speed = 0.4
export(Material) var material
var d = 0


const timer = preload("res://Effect/ParticleTimer.tscn")
const explosion = preload("res://Explosion/Plane.tscn")
const debris = preload("res://Effect/Debris.tscn")
const bullet = preload("res://Bullet/SmallBullet.tscn")
const hit = preload("res://Explosion/Hit.tscn")
signal on_destroyed
signal on_damaged

var solo = true

onready var smoke = $Smoke

const fireCooldown = 5
var cooldownLeft = fireCooldown
func _ready():
	$Area.connect("area_entered", self, "on_area_entered")
	
	
func set_solo(s):
	solo = s
	if s:
		$Wraparound.start()
		$GunTimer.start()
	else:
		$Wraparound.stop()
		$GunTimer.stop()
func on_area_entered(other):
	var p = other.get_parent()
	if p.is_in_group("Player"):
		p.on_damage(10)
		
var prevPos = Vector2(0, 0)
func _process(delta):
	# use global coordinates, not local to node
	if !solo:
		var p = get_global_transform().origin
		p = Vector2(p.x, p.z)
		
		var offset = p - prevPos
		if offset.length() > 0:
			var angle = -PI/2 - offset.angle() - get_parent_rotation()
			rotation.y = lerp_angle(rotation.y, angle, 0.1)
			
			prevPos = p
		return
	
	var player = $Wraparound.player
	var world = player.get_parent()
	var p = player.get_camera_origin()
	if cooldownLeft <= delta and player.is_inside_tree():
		var offset = p - get_global_transform().origin
		var distance = offset.length()
		var vel = -get_global_transform().basis.z * speed
		var playerVel = -player.get_global_transform().basis.z * player.speed
		var velDiff = playerVel - vel
		var bulletSpeed = 1.5
		#var future_offset = offset + velDiff * distance / (bulletSpeed * 60)
		var firing = false
		if distance < 80:
			var result = get_world().direct_space_state.intersect_ray(transform.origin, player.transform.origin, [$Area], 2147483647, false, true)
			var clear = result.empty() or (result["collider"].get_parent() == player)
			
			if clear:
				var b = bullet.instance()
				
				world.add_child(b)
				b.set_global_transform(get_global_transform())
				b.vel = 1.2 * offset.normalized() + vel
				
				cooldownLeft = fireCooldown
				firing = true
		if !firing:
			cooldownLeft = 0.5
	else:
		cooldownLeft -= delta
	
	
	d += delta
	if (($Left.get_global_transform().origin - p).length() < ($Right.get_global_transform().origin - p).length()):
		rotation_degrees.y += delta * 360 / 30
	else:
		rotation_degrees.y -= delta * 360 / 30
		
	self.translate(Vector3(0, 0, -speed))
func on_damage(projectile):
	var damage = projectile.damage
	hp -= damage
	
	var world = $Wraparound.player.get_parent()
	if(hp <= 0):
		smoke.emitting = false
		var p = smoke.get_parent()
		if p:
			p.remove_child(smoke)
		
		var t = timer.instance()
		t.time = 5
		t.transform.origin = smoke.get_global_transform().origin
		t.call_deferred("add_child", smoke)
		
		world.call_deferred("add_child", t)
		
		var e = explosion.instance()
		e.emitting = true
		e.process_material.set("initial_velocity", -speed * 15)
		world.add_child(e)
		e.set_global_transform(get_global_transform())
		
		var vel = -get_global_transform().basis.z * speed * 15
		var shards = $Destruction.destroy()
		for s in shards.get_children():
			var angle = rand_range(0, PI*2)
			var speed = rand_range(1, 5)
			s.linear_velocity = vel + Vector3(speed * cos(angle), 0, speed * sin(angle))	
			var m = 90
			s.angular_velocity = Vector3(rand_range(-m, m), rand_range(-m, m), rand_range(-m, m))
			
			var st = s.get_global_transform()
			s.get_parent().remove_child(s)
			world.add_child(s)
			s.set_global_transform(st)
		emit_signal("on_destroyed", self, projectile)
		call_deferred("queue_free")
	else:
		
		#var e = hit.instance()
		#world.add_child(e)
		#e.emitting = true
		#e.set_global_transform(projectile.get_global_transform())
		# Create some debris
		
		for i in range(3):
			var vel = -get_global_transform().basis.z * speed * 15
			var d = debris.instance()
			world.add_child(d)
			d.get_node("Body").set_surface_material(0, material)
			d.set_global_transform(projectile.get_global_transform())
			
			var p = d.get_global_transform().origin
			var angle = randf() * PI * 2
			d.linear_velocity = vel + projectile.vel.normalized() * 2 + 2 * Vector3(cos(angle), 0, sin(angle))
			var m = 90
			d.angular_velocity = Vector3(rand_range(-m, m), rand_range(-m, m), rand_range(-m, m))
		
		if hp <= 10:
			smoke.emitting = true
			smoke.process_material.set("initial_velocity", -speed * 60)
		
		emit_signal("on_damaged", self, projectile)


func get_parent_rotation():
	var result = 0
	var n = get_parent()
	while n:
		if n is Spatial:
			result += n.rotation.y
		n = n.get_parent()
	return result
		
