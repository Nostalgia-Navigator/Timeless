extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var speed = 1
var exhaust
func _ready():
	exhaust = get_node("Exhaust")
	pass # Replace with function body.
func _process(delta):
	var thrusting = false
	var braking = false
	var accel = 0.25/30
	var turning = false
	var turn = PI/75
	var turnAngle = PI * 6 / 16
	if(Input.is_key_pressed(KEY_DOWN)):
		braking = true
		if(speed > 0.6):
			speed -= accel
	if(Input.is_key_pressed(KEY_UP)):
		thrusting = true
		exhaust.emitting = true
		if(speed < 2.4):
			speed += accel
	if(Input.is_key_pressed(KEY_LEFT)):
		self.rotation.y += turn
		self.rotation.z += (turnAngle - self.rotation.z) / 20
		turning = true
	if(Input.is_key_pressed(KEY_RIGHT)):
		self.rotation.y -= turn
		self.rotation.z += (-turnAngle - self.rotation.z) / 20
		turning = true
	
	if(Input.is_key_pressed(KEY_SPACE)):
		
		pass
	
	if(!thrusting):
		exhaust.emitting = false
		if speed > 1.2:
			speed -= accel
	if(!braking):
		if speed < 1.2:
			speed += accel
	if(!turning):
		self.rotation_degrees.z *= 0.9
	
	
	self.translate(Vector3(0, 0, -speed))
