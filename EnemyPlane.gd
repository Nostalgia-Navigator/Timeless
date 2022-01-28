extends Spatial

export(int) var hp = 15
export(float) var speed = 0.4
var smoke
var timer = preload("res://ParticleTimer.tscn")
var explosion = preload("res://Explosion.tscn")
var debris = preload("res://Debris.tscn")

var wraparound = 128
var player

var d=0
func _ready():
	smoke = $Smoke
	player = get_tree().get_root().get_child(0).get_node("Player")
func _process(delta):
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
		pass
	
	
func on_damage(damage):
	hp -= damage
	if(hp <= 0):
		smoke.emitting = false
		smoke.get_parent().remove_child(smoke)
		
		var t = timer.instance()
		t.time = 5
		t.transform.origin = smoke.get_global_transform().origin
		t.call_deferred("add_child", smoke)
		
		get_parent().call_deferred("add_child", t)
		queue_free()
		
		var e = explosion.instance()
		e.transform.origin = get_global_transform().origin
		e.emitting = true
		e.process_material.set("initial_velocity", -speed * 60)
		get_parent().add_child(e)
		
		var vel = -get_global_transform().basis.z * speed * 60
		for i in range(20):
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
