extends Spatial

export(float) var speed = 0
const standardSpeed = 0.6
const brakeSpeed = 0.5
const thrustSpeed = 2.4
var exhaust
const bullet = preload("res://PlayerBullet1.tscn")
const explosion = preload("res://Explosion.tscn")
const debris = preload("res://Debris.tscn")
const shake = preload("res://Shake.tscn")
const bombdrop = preload("res://BombDrop.tscn")
const fireCooldown = 0.1
var fireCooldownLeft = 0

const bombCooldown = 0.8
var bombCooldownLeft = 0

const fullHP = 30
var hp = fullHP
var parent
export(bool) var playing = false
export(bool) var vulnerable = false
func intro_done(a):
	if(a == "Takeoff"):
		playing = true
		speed = standardSpeed
		$AnimationPlayer.play("Invulnerable")
signal on_damaged
func _ready():
	exhaust = $Exhaust
	parent = get_parent()
func on_damage(projectile):
	
	var dmg = projectile
	if projectile is Node:
		dmg = projectile.damage
	if(!vulnerable):
		return
	emit_signal("on_damaged")
	if hp <= dmg:
		var e = explosion.instance()
		e.transform.origin = get_global_transform().origin
		e.emitting = true
		e.process_material.set("initial_velocity", -speed * 15 )
		get_parent().add_child(e)
		
		var vel = -get_global_transform().basis.z * speed * 15
		var shards = $Destruction.destroy()
		for s in shards.get_children():
			var angle = rand_range(0, PI*2)
			var speed = rand_range(1, 5)
			s.linear_velocity = vel + Vector3(speed * cos(angle), 0, speed * sin(angle))	
			var m = 90
			s.angular_velocity = Vector3(rand_range(-m, m), rand_range(-m, m), rand_range(-m, m))
		
		
		exhaust.emitting = false
		remove_child(exhaust)
		
		var n = Spatial.new()
		n.transform.origin = get_global_transform().origin
		n.add_child(exhaust)
		get_parent().add_child(n)
		
		#for i in range(10):
		#	var d = debris.instance()
		#	d.transform.origin = get_global_transform().origin
		#	var angle = rand_range(0, PI*2)
		#	var speed = rand_range(1, 5)
		#	d.linear_velocity = vel + Vector3(speed * cos(angle), 0, speed * sin(angle))
		#	
		#	var m = 90
		#	d.angular_velocity = Vector3(rand_range(-m, m), rand_range(-m, m), rand_range(-m, m))
		#	var body = d.get_node("Body")
		#	var material = body.get_surface_material(0)
		#	material.albedo_color = get_child(0).mesh.surface_get_material(0).albedo_color
		#	body.set_surface_material(0, material)
		#	get_parent().add_child(d)
		
		var t = Timer.new()
		t.wait_time = 4
		t.one_shot = true
		t.connect("timeout", self, "respawn")
		t.connect("timeout", t, "queue_free")
		parent.add_child(t)
		t.start()
		parent.remove_child(self)
	else:
		hp -= dmg
func respawn():
	parent.add_child(self)
	hp = fullHP
	
	var p = exhaust.get_parent()
	p.remove_child(exhaust)
	add_child(exhaust)
	p.queue_free()
	
	$AnimationPlayer.play("Invulnerable")
	
func get_camera_origin():
	
	if is_inside_tree():
		return get_global_transform().origin
	return transform.origin
func _process(delta):
	
	#var ray_length = 1000
	#var mouse_pos = get_viewport().get_mouse_position()
	#var camera = get_node("camera")
	#var from = camera.project_ray_origin(mouse_pos)
	#var to = from + camera.project_ray_normal(mouse_pos) * ray_length
	
	if(!playing):
		return
	
	fireCooldownLeft -= delta
	bombCooldownLeft -= delta
	
	var thrusting = false
	var braking = false
	var accel = 0.25/30
	var turning = false
	var turn = PI/75
	var turnAngle = PI * 6 / 16
	
	
	if(Input.is_key_pressed(KEY_DOWN)):
		braking = true
		if(speed > brakeSpeed):
			speed -= accel
			
	var body_rotation = $Body.rotation
	if(Input.is_key_pressed(KEY_UP)):
		thrusting = true
		exhaust.emitting = true
		exhaust.process_material.set("initial_velocity", -speed * 30)
		if(speed < thrustSpeed):
			speed += accel
	if(Input.is_key_pressed(KEY_LEFT)):
		body_rotation.z += (turnAngle - body_rotation.z) / 20
		
		self.rotation.y += turn
		turning = true
	if(Input.is_key_pressed(KEY_RIGHT)):
		body_rotation.z += (-turnAngle - body_rotation.z) / 20
		
		self.rotation.y -= turn
		turning = true
	if(!thrusting):
		exhaust.emitting = false
		if speed > standardSpeed:
			speed -= accel
	if(!braking):
		if speed < standardSpeed:
			speed += accel
	if(!turning):
		body_rotation.z *= 0.9
		
	$Body.rotation = body_rotation
	
	
	self.translate(Vector3(0, 0, -speed))
	
	if(Input.is_key_pressed(KEY_X)) and fireCooldownLeft <= 0:
		var b = bullet.instance()
		get_parent().add_child(b)
		b.transform.origin = $Gun.get_global_transform().origin
		b.rotation.y = self.rotation.y
		b.vel = -get_global_transform().basis.z * (speed + 2)
		fireCooldownLeft = fireCooldown
	if(Input.is_key_pressed(KEY_Z)) and bombCooldownLeft <= 0:
		var b = bombdrop.instance()
		b.transform.origin = $Crosshair.get_global_transform().origin
		b.rotation_degrees.y = rotation_degrees.y
		get_parent().add_child(b)
		bombCooldownLeft = bombCooldown
		


var star = preload("res://Blender/StarParticle.tscn")
func _on_area_entered(area):
	if area.is_in_group("Goodie"):
		var p = area.get_parent().get_parent().get_parent().get_parent()
		p.queue_free()
		
		for i in range(0, 16):
			var s = star.instance()
			var m = [p.color1, p.color2][i%2]
			for c in s.get_children():
				if c is MeshInstance:
					c.set_surface_material(0, m)
			s.transform.origin = p.get_global_transform().origin
			var speed = rand_range(16, 24)
			var angle = randf() * PI * 2
			s.angular_velocity = Vector3(0, randf() * PI*2 + PI*2, 0)
			s.linear_velocity = Vector3(speed*cos(angle),0,speed*sin(angle))
			get_parent().add_child(s)
		
