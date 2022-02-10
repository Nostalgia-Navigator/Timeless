extends Spatial
const bullet = preload("res://Bullet/SmallBullet.tscn")

enum BehaviorType { meander, patrol, pursue } 
export(BehaviorType) var behavior = BehaviorType.patrol

export(float) var speed = 0.4
var planes = []

var d = 0
func _ready():
	for c in get_children():
		if c.is_in_group("Plane"):
			planes.append(c)
			c.set_solo(false)
			c.connect("on_damaged", self, "on_plane_damaged")
			c.connect("on_destroyed", self, "remove_plane")
func on_plane_damaged(e, projectile):
	if len(planes) > 0 and randi()%10 == 0:
		var attacker = planes[randi() % len(planes)]
		
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
func fire(timer):
	
	var attacker = planes[randi() % len(planes)]
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
		var bulletSpeed = 1.5
		#var future_offset = offset + velDiff * distance / (bulletSpeed * 60)
		if distance < 80:
			var result = get_world().direct_space_state.intersect_ray(transform.origin, player.transform.origin, [$Area], 2147483647, false, true)
			var clear = result.empty() or (result["collider"].get_parent() == player)
			if clear:
				var b = bullet.instance()
				world.add_child(b)
				b.set_global_transform(attacker.get_global_transform())
				b.vel = 1.2 * offset.normalized() + vel
				timer.on_fired()

func _process(delta):
	
	var p = $Wraparound.player.get_global_transform().origin
	
	
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
	
	pass
