extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 0
const standardSpeed = 0.9
const brakeSpeed = 0.5
const thrustSpeed = 2.4
var exhaust
const bullet = preload("res://PlayerBullet1.tscn")
const explosion = preload("res://Explosion.tscn")
const debris = preload("res://Debris.tscn")
const cooldown = 0.1
var cooldownLeft = 0
var hp = 5
var parent
func _ready():
	exhaust = get_node("Exhaust")
	parent = get_parent()
func on_damage(dmg):
	if hp <= dmg:
		var e = explosion.instance()
		e.transform.origin = get_global_transform().origin
		e.emitting = true
		e.process_material.set("initial_velocity", -speed * 15 )
		get_parent().add_child(e)
		
		var vel = -get_global_transform().basis.z * speed * 60 * 0
		for i in range(10):
			var d = debris.instance()
			d.transform.origin = get_global_transform().origin
			var angle = rand_range(0, PI*2)
			var speed = rand_range(1, 5)
			d.linear_velocity = vel + Vector3(speed * cos(angle), 0, speed * sin(angle))
			
			var m = 90
			d.angular_velocity = Vector3(rand_range(-m, m), rand_range(-m, m), rand_range(-m, m))
			
			var body = d.get_node("Body")
			var material = body.get_surface_material(0)
			material.albedo_color = get_child(0).mesh.surface_get_material(0).albedo_color
			body.set_surface_material(0, material)
			
			get_parent().add_child(d)
			
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
	hp = 5
func _process(delta):
	cooldownLeft -= delta
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
	if(Input.is_key_pressed(KEY_UP)):
		thrusting = true
		exhaust.emitting = true
		exhaust.process_material.set("initial_velocity", -speed * 30)
		if(speed < thrustSpeed):
			speed += accel
	if(Input.is_key_pressed(KEY_LEFT)):
		self.rotation.y += turn
		self.rotation.z += (turnAngle - self.rotation.z) / 20
		turning = true
	if(Input.is_key_pressed(KEY_RIGHT)):
		self.rotation.y -= turn
		self.rotation.z += (-turnAngle - self.rotation.z) / 20
		turning = true
	if(!thrusting):
		exhaust.emitting = false
		if speed > standardSpeed:
			speed -= accel
	if(!braking):
		if speed < standardSpeed:
			speed += accel
	if(!turning):
		self.rotation_degrees.z *= 0.9
	
	
	self.translate(Vector3(0, 0, -speed))
	
	if(Input.is_key_pressed(KEY_SPACE)) and cooldownLeft <= 0:
		var b = bullet.instance()
		get_parent().add_child(b)
		b.transform.origin = $Gun.get_global_transform().origin
		b.rotation.y = self.rotation.y
		b.vel = -get_global_transform().basis.z * (speed + 2)
		cooldownLeft = cooldown

