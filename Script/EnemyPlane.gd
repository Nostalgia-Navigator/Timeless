extends Spatial

const ADJUST = 40
export(String) var planeName
export(NodePath) var body
export(int, 0, 2, 1) var markerType
export(int) var hp = 100
onready var speed = Game.planeSpeed[Game.difficulty]
export(Material) var material
export(int) var score = 0
var d = 0

var turnLeft = 180

const timer = preload("res://Effect/ParticleTimer.tscn")
const explosion = preload("res://Explosion/Plane.tscn")
const chunk = preload("res://Effect/Debris.tscn")
const bullet = preload("res://Bullet/SmallBullet.tscn")
const hit = preload("res://Explosion/Hit.tscn")
signal on_destroyed
signal on_damaged

const gunshot = preload("res://Sounds/Fire/Gunshot - snd .1019.dat.wav")

var solo = true
onready var player = get_tree().get_root().get_node("Main/Player")
const fireCooldown = 5
var cooldownLeft = fireCooldown

export(PackedScene) var debris
const shardTemplate = preload("res://Effect/DebrisTemplate.tscn")
const DestructionUtils = preload("res://addons/destruction/DestructionUtils.gd")
onready var shards = DestructionUtils.create_shards(debris.instance(), shardTemplate)


var smoke
var left
var right

func get_body():
	return get_node(body)
func _ready():
	left = Spatial.new()
	left.transform.origin = Vector3(-1, 0, 0)
	add_child(left)
	
	right = Spatial.new()
	right.transform.origin = Vector3(1, 0, 0)
	add_child(right)

	smoke = preload("res://Effect/PlaneSmoke.tscn").instance()
	add_child(smoke)
func set_solo(s):
	solo = s
func on_area_entered(other):
	#var p = other.get_parent()
	#if p.is_in_group("Player"):
	#	p.on_damage(rand_range(10, 25))
	pass
		
var prevPos = Vector2(0, 0)
func _physics_process(delta):
	# use global coordinates, not local to node
	if !solo:
		var p = get_global_transform().origin
		p = Vector2(p.x, p.z)
		
		var offset = p - prevPos
		if offset.x != 0 || offset.y != 0:
			var angle = -PI/2 - offset.angle() - get_parent_rotation()
			rotation.y = lerp_angle(rotation.y, angle, 0.1)
			
			prevPos = p
		return
	
	var world = player.get_parent()
	var p = player.get_camera_origin()
	if cooldownLeft <= delta and player.is_inside_tree():
		var firing = false
		var offset = p - get_global_transform().origin
		if offset.length() < 80:
			var result = get_world().direct_space_state.intersect_ray(transform.origin, player.transform.origin, [$Area], 2147483647, false, true)
			var clear = result.empty() or (result["collider"].get_parent() == player)
			
			if clear:
				var s = AudioStreamPlayer.new()
				s.stream = gunshot
				Bgm.add_child(s)
				s.play()
				s.connect("finished", s, "queue_free")
				
				var b = bullet.instance()
				b.damage = rand_range(5, 25)
				world.add_child(b)
				
				var vel = -get_global_transform().basis.z * speed
				b.source = self
				b.set_global_transform(get_global_transform())
				b.vel = 1 * ADJUST * offset.normalized() + vel
				
				cooldownLeft = fireCooldown
				firing = true
		if !firing:
			cooldownLeft = 0.5
	else:
		cooldownLeft -= delta
	d += delta
	if turnLeft != 0:
		var turnDelta = sign(turnLeft) * delta * 6 * 360 / 30
		if abs(turnDelta) > abs(turnLeft):
			turnDelta = turnLeft
		rotation_degrees.y += turnDelta
		turnLeft -= turnDelta
	elif ((left.get_global_transform().origin - p).length() < (right.get_global_transform().origin - p).length()):
		rotation_degrees.y += delta * 360 / 30
	else:
		rotation_degrees.y -= delta * 360 / 30
		
	self.translate(Vector3(0, 0, -speed * delta))

func on_damage(projectile):
	var damage = projectile.damage
	hp -= damage
	
	var h = hit.instance()
	get_parent().add_child(h)
	h.emitting = true
	h.set_global_transform(projectile.get_global_transform())
	
	var world = player.get_parent()
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
		e.process_material.set("initial_velocity", -speed)
		world.add_child(e)
		e.set_global_transform(get_global_transform())
		
		var vel = -get_global_transform().basis.z * speed
		for s in shards.get_children():
			#var offset = (s.get_global_transform().origin - transform.origin)
			var angle = (rand_range(0, PI*2))
			var speed = rand_range(10, 20)
			var y = rand_range(-1, 1)
			s.linear_velocity = vel + speed * Vector3(cos(angle), y, sin(angle))	
			var m = 30
			s.angular_velocity = Vector3(rand_range(-m, m), 0, rand_range(-m, m))
		world.add_child(shards)
		shards.set_global_transform(get_global_transform())
		
		Game.destroyed.aircraft += 1
		
		
		var s = AudioStreamPlayer.new()
		s.stream = planeExplosion[randi()%len(planeExplosion)]
		Bgm.add_child(s)
		s.play()
		s.connect("finished", s, "queue_free")
		
		emit_signal("on_destroyed", self, projectile)
		call_deferred("queue_free")
	else:
		for i in range(3):
			var vel = -get_global_transform().basis.z * speed * 15 / ADJUST
			var d = chunk.instance()
			world.add_child(d)
			d.get_node("Body").set_surface_material(0, material)
			d.set_global_transform(projectile.get_global_transform())
			
			var p = d.get_global_transform().origin
			var angle = randf() * PI * 2
			d.linear_velocity = vel - projectile.vel.normalized() * 20 + 5 * Vector3(cos(angle), 0, sin(angle))
			var m = 90
			d.angular_velocity = Vector3(rand_range(-m, m), 0, rand_range(-m, m))
		if hp <= 10:
			smoke.emitting = true
			smoke.process_material.set("initial_velocity", -speed)
		
		
		var s = AudioStreamPlayer.new()
		s.stream = planeHit[randi()%len(planeHit)]
		Bgm.add_child(s)
		s.play()
		s.connect("finished", s, "queue_free")
		
		
		emit_signal("on_damaged", self, projectile)
const planeHit = [
	preload("res://Sounds/Hit/PlaneHit - snd .1008.dat.wav"),
	preload("res://Sounds/Hit/PlaneHit - snd .1009.dat.wav"),
	preload("res://Sounds/Hit/PlaneHit - snd .1010.dat.wav"),
	preload("res://Sounds/Hit/PlaneHit - snd .1011.dat.wav")
]
const planeExplosion = [
	preload("res://Sounds/Explosion/Plane - snd .1012.dat.wav"),
	preload("res://Sounds/Explosion/Plane - snd .1013.dat.wav"),
	preload("res://Sounds/Explosion/Plane - snd .1014.dat.wav"),
	preload("res://Sounds/Explosion/Plane - snd .1015.dat.wav"),
	preload("res://Sounds/Explosion/Plane - snd .1016.dat.wav"),
	preload("res://Sounds/Explosion/Plane - snd .1017.dat.wav"),
	preload("res://Sounds/Explosion/Plane - snd .1018.dat.wav")
]
func get_parent_rotation():
	var result = 0
	var n = get_parent()
	while n:
		if n is Spatial:
			result += n.rotation.y
		n = n.get_parent()
	return result
		
