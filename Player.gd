extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 0
var standardSpeed = 0.9
var brakeSpeed = 0.5
var thrustSpeed = 2.4
var exhaust
var bullet = preload("res://PlayerBullet1.tscn")
var cooldown = 1
func _ready():
	exhaust = get_node("Exhaust")
func _process(delta):
	cooldown -= delta
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
	if(Input.is_key_pressed(KEY_SPACE)) and cooldown <= 0:
		var b = bullet.instance()
		get_parent().add_child(b)
		b.transform.origin = $Gun.get_global_transform().origin
		b.rotation.y = self.rotation.y
		b.vel = -get_global_transform().basis.z * (speed + 2)
		cooldown = 0.2
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
