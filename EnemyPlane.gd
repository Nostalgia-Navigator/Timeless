extends Spatial

export(int) var hp = 15
export(float) var speed = 0.4
var smoke
const timer = preload("res://ParticleTimer.tscn")
const explosion = preload("res://Explosion.tscn")
const debris = preload("res://Debris.tscn")
const bullet = preload("res://SmallBullet.tscn")

const wraparound = 128
var player

var d=0
const fireCooldown = 5
var cooldownLeft = fireCooldown
func _ready():
	smoke = $Smoke
	var root = get_tree().get_root().get_node("Main")
	player = root.get_node("Player")
	$Area.connect("area_entered", self, "on_area_entered")
func on_area_entered(other):
	var p = other.get_parent()
	if p.is_in_group("Player"):
		p.on_damage(10)
func _process(delta):
	# use global coordinates, not local to node
	var firing = false
	if cooldownLeft <= delta and player.is_inside_tree():
		var offset = player.transform.origin - transform.origin
		var distance = offset.length()
		var vel = -get_global_transform().basis.z * speed
		var playerVel = -player.get_global_transform().basis.z * player.speed
		var velDiff = playerVel - vel
		var bulletSpeed = 1.5
		
		
		
		#var future_offset = offset + velDiff * distance / (bulletSpeed * 60)
		if distance < 80:
			var result = get_world().direct_space_state.intersect_ray(transform.origin, player.transform.origin, [$Area], 2147483647, false, true)
			var c = result["collider"]
			var clear = c != null and c.get_parent() == player
			
			if clear:
				var b = bullet.instance()
				b.transform.origin = get_global_transform().origin
				b.vel = 1.2 * offset.normalized() + vel
				
				get_parent().add_child(b)
				cooldownLeft = fireCooldown
				firing = true
		if !firing:
			cooldownLeft = 0.5
	else:
		cooldownLeft -= delta
		
	self.translate(Vector3(0, 0, -speed))
	d += delta
	if d > 0.5:
		var dx = transform.origin.x - player.transform.origin.x
		if dx < -wraparound:
			transform.origin.x += 2 * wraparound
		elif dx > wraparound:
			transform.origin.x -= 2 * wraparound
			
		var dz = transform.origin.z - player.transform.origin.z
		if dz < -wraparound:
			transform.origin.z += 2 * wraparound
		elif dz > wraparound:
			transform.origin.z -= 2 * wraparound
		d = 0
func on_damage(damage):
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
		e.transform.origin = get_global_transform().origin
		e.emitting = true
		e.process_material.set("initial_velocity", -speed * 60 * 1.25)
		get_parent().add_child(e)
		
		var vel = -get_global_transform().basis.z * speed * 60
		for i in range(10):
			var d = debris.instance()
			d.transform.origin = get_global_transform().origin
			var angle = rand_range(0, PI*2)
			var speed = rand_range(1, 20)
			d.linear_velocity = vel + Vector3(speed * cos(angle), 0, speed * sin(angle))
			
			var m = 10
			d.angular_velocity = Vector3(rand_range(-m, m), rand_range(-m, m), rand_range(-m, m))
			
			var body = d.get_node("Body")
			var material = body.get_surface_material(0)
			material.albedo_color = get_child(0).mesh.surface_get_material(0).albedo_color
			body.set_surface_material(0, material)
			
			get_parent().add_child(d)
	elif hp <= 10:
		smoke.emitting = true
		smoke.process_material.set("initial_velocity", -speed * 60)
		pass
