extends Spatial

enum BehaviorType { meander, patrol, pursue } 

export(int, 0, 2, 1) var markerType
export(float) var speed = 0.4
export(Material) var material
export(BehaviorType) var behavior = BehaviorType.patrol


const timer = preload("res://ParticleTimer.tscn")
const explosion_hit = preload("res://HitExplosion.tscn")
const explosion_section = preload("res://SectionExplosion.tscn")
const explosion_boss = preload("res://BossExplosion.tscn")
const explosion_long = preload("res://LongExplosion.tscn")
const debris = preload("res://Debris.tscn")
const bullet = preload("res://SmallBullet.tscn")
const smoke = preload("res://BossSmoke.tscn")
signal on_destroyed
signal on_damaged

const BossGun = preload("res://BossGun.gd")
var sections = []

const sectionHp = 20
var hp = sectionHp

func _ready():
	$Area.connect("area_entered", self, "on_area_entered")
	for c in get_children():
		if c is BossGun:
			sections.append(c)
			
func on_area_entered(other):
	var p = other.get_parent()
	if p.is_in_group("Player"):
		p.on_damage(10)
var d = 0
func _process(delta):
	# use global coordinates, not local to node
	var firing = false
	var player = $Wraparound.player
	var world = player.get_parent()
	var p = player.get_camera_origin()
	if get_parent().is_in_group("Plane"):
		return
	d += delta
	if behavior == BehaviorType.meander:
		rotation_degrees.y += sin(d * (PI * 2) / 8) * 3 / 15
	if behavior == BehaviorType.patrol:
		rotation_degrees.y += delta * 360 / 60
	elif behavior == BehaviorType.pursue:
		if (($Left.get_global_transform().origin - p).length() < ($Right.get_global_transform().origin - p).length()):
			rotation_degrees.y += delta * 360 / 60
		else:
			rotation_degrees.y -= delta * 360 / 60
	self.translate(Vector3(0, 0, -speed))
func on_damage(projectile):
	var world = $Wraparound.player.get_parent()
	hp -= projectile.damage
	if hp > 0:
		var vel = -get_global_transform().basis.z * speed * 15
		
		for i in range(5):
			var d = debris.instance()
			world.add_child(d)
			d.get_node("Body").set_surface_material(0, material)
			d.set_global_transform(projectile.get_global_transform())
			var p = d.get_global_transform().origin
			var angle = randf() * PI * 2
			d.linear_velocity = vel + projectile.vel.normalized() * 2 + 2 * Vector3(cos(angle), 0, sin(angle))
			var m = 90
			d.angular_velocity = Vector3(rand_range(-m, m), rand_range(-m, m), rand_range(-m, m))
		
		
		var hitExplosion = explosion_hit.instance()
		hitExplosion.emitting = true
		#e.process_material.set("initial_velocity", 10)
		add_child(hitExplosion)
		hitExplosion.set_global_transform(projectile.get_global_transform())
		
		
		return
	while(hp <= 0):
		if len(sections) == 0:
			for i in get_explosion_points($ExplosionPoints):
				var bossExplosion = explosion_boss.instance()
				bossExplosion.emitting = true
				#e.process_material.set("initial_velocity", 10)
				world.add_child(bossExplosion)
				bossExplosion.set_global_transform(i.get_global_transform())
				
				var longExplosion = explosion_long.instance()
				longExplosion.emitting = true
				#e.process_material.set("initial_velocity", 10)
				world.add_child(longExplosion)
				longExplosion.set_global_transform(i.get_global_transform())
				
				
			var vel = -get_global_transform().basis.z * speed * 15
			var shards = $Destruction.destroy()
			for s in shards.get_children():
				var angle = rand_range(0, PI*2)
				var speed = rand_range(0, 0)
				s.linear_velocity = vel + Vector3(speed * cos(angle), 0, speed * sin(angle))	
				var m = 90
				s.angular_velocity = Vector3(rand_range(-m, m), rand_range(-m, m), rand_range(-m, m))
				
			
			
			
			emit_signal("on_destroyed", self)
			call_deferred("queue_free")
			return
		hp += sectionHp
		
		var section = sections.back()
		sections.pop_back()
		
		var hitExplosion = explosion_hit.instance()
		hitExplosion.emitting = true
		#e.process_material.set("initial_velocity", 10)
		add_child(hitExplosion)
		hitExplosion.set_global_transform(section.get_global_transform())
		
		var sectionExplosion = explosion_section.instance()
		sectionExplosion.emitting = true
		#e.process_material.set("initial_velocity", 10)
		add_child(sectionExplosion)
		sectionExplosion.set_global_transform(section.get_global_transform())
		
		var sectionSmoke = smoke.instance()
		sectionSmoke.emitting = true
		add_child(sectionSmoke)
		sectionSmoke.set_global_transform(section.get_global_transform())
		
			

func get_explosion_points(n):
	if n.get_child_count() == 0:
		return [n]
	var a = []
	for c in n.get_children():
		a.append_array(get_explosion_points(c))
	return a
	
