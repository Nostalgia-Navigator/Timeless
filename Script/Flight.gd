extends Spatial
const bullet = preload("res://Bullet/SmallBullet.tscn")
const gunshot = preload("res://Sounds/Fire/Gunshot - snd .1019.dat.wav")

enum BehaviorType { meander, patrol, pursue } 
export(BehaviorType) var behavior = BehaviorType.patrol
onready var speed = Game.planeSpeed[Game.difficulty]
onready var turnRate = 360 / 60
var planes = []
var d = 0
func _ready():
	call_deferred("register_planes")
func register_planes():
	var i = 0
	for c in get_children():
		if c.is_in_group("Plane"):
			if c in planes:
				continue
			i += 1
			planes.append(c)
			c.set_solo(false)
			c.connect("on_damaged", self, "on_plane_damaged")
			c.connect("on_destroyed", self, "remove_plane")
	#print(i)
func on_plane_damaged(e, projectile):
	if randi()%10 > 0:
		return
	var attacker = get_random_plane()
	if attacker == null:
		return
	var t = attacker.get_global_transform()
	remove_child(attacker)
	get_parent().add_child(attacker)
	attacker.set_global_transform(t)
	attacker.set_solo(true)
	remove_plane(attacker, null)
func remove_plane(e, projectile):
	planes.erase(e)
	if len(planes) == 0:
		queue_free()

func get_random_plane():
	var alive = []
	for p in planes:
		if is_instance_valid(p):
			alive.append(p)
	if len(alive) > 0:
		planes = alive
		return alive[randi() % len(alive)]
	queue_free()
	return null
func fire(timer):
	
	var attacker = get_random_plane()
	if attacker == null:
		return
	var a = attacker.get_global_transform().origin
	
	var player = $Wraparound.player
	var world = player.get_parent()
	var p = player.get_camera_origin()
	if player.playing:
		var offset = p - a
		var distance = offset.length()
		var vel = -get_global_transform().basis.z * speed
		var playerVel = -player.get_global_transform().basis.z * player.speed
		var velDiff = playerVel - vel
		#var future_offset = offset + velDiff * distance / (bulletSpeed * 60)
		if distance < 80:
			var child_areas = []
			for n in planes:
				child_areas.append(n.get_node("Area"))
			var result = get_world().direct_space_state.intersect_ray(transform.origin, player.transform.origin, child_areas, 2147483647, false, true)
			var clear = result.empty() or (result["collider"].get_parent() == player)
			if clear:
				var s = AudioStreamPlayer.new()
				s.stream = gunshot
				Bgm.add_child(s)
				s.play()
				s.connect("finished", s, "queue_free")
				
				var b = bullet.instance()
				world.call_deferred("add_child", b)
				b.set_global_transform(attacker.get_global_transform())
				b.vel = 1 * 40 * offset.normalized() + vel
				timer.on_fired()
func _physics_process(delta):
	var p = $Wraparound.player.get_global_transform().origin
	d += delta
	if behavior == BehaviorType.meander:
		rotation_degrees.y += sin(d * (PI * 2) / 12) * 3 / 15
	if behavior == BehaviorType.patrol:
		rotation_degrees.y += delta * turnRate
	elif behavior == BehaviorType.pursue:
		if (($Left.get_global_transform().origin - p).length() < ($Right.get_global_transform().origin - p).length()):
			rotation_degrees.y += delta * turnRate
		else:
			rotation_degrees.y -= delta * turnRate
	
	self.translate(Vector3(0, 0, -speed * delta))
