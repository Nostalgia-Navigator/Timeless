extends MeshInstance


enum BulletType { Spike, Wave, Zigzag, Rainbow }
#export(BulletType) var bullet = BulletType.Spike
onready var main = get_parent()
var cooldown_timer
var fire_timer

func _ready():
	cooldown_timer = Timer.new()
	add_child(cooldown_timer)
	cooldown_timer.wait_time = 5
	cooldown_timer.connect("timeout", self, "fire")
	
	fire_timer = Timer.new()
	add_child(fire_timer)
	fire_timer.wait_time = 1
	fire_timer.connect("timeout", self, "fire")
	
	var init_timer = Timer.new()
	add_child(init_timer)
	init_timer.wait_time = randf()*8
	init_timer.connect("timeout", fire_timer, "start")
	init_timer.connect("timeout", init_timer, "queue_free")
	init_timer.start()
	
	
const spike = preload("res://Bullet/SpikeBullet.tscn")
const wave = preload("res://Bullet/WaveBullet.tscn")
const zigzag = preload("res://Bullet/ZigzagBullet.tscn")
const rainbow = preload("res://Bullet/RainbowBullet.tscn")
const bullets = [spike, wave, zigzag, rainbow]

const gunshot = preload("res://Sounds/Fire/Gunshot - snd .1019.dat.wav")
#const zigzag = preload("res://Blender/ZigZagBullet.tscn")
func cooldown():
	cooldown_timer.stop()
	fire_timer.start()
func fire():
	var player = main.get_node("Wraparound").player
	var from = get_global_transform().origin
	var to = player.get_global_transform().origin
	
	fire_timer.stop()
	cooldown_timer.start()
	var bullet = randi()%len(bullets)
	var s = bullets[bullet].instance()
	if bullet == BulletType.Spike:
		pass
	elif bullet == BulletType.Wave or bullet == BulletType.Zigzag:
		s.speed = 1 * 40
	elif bullet == BulletType.Rainbow:
		var speed = 1 * 40
		var angle = (Vector2(to.x, to.z) - Vector2(from.x, from.z)).angle()
		s.vel = Vector3(speed * cos(angle), 0, speed * sin(angle))
	
	s.damage = rand_range(5, 25)
	
	Game.play_sound(gunshot)
	
	var world = player.get_parent()
	world.add_child(s)
	s.set_global_transform(get_global_transform())
	#s.rotation.y -= PI/2
	#s.rotation.y = -(s.rotation.y - PI/2)
func _process(delta):
	var player = main.get_node("Wraparound").player
	var from = get_global_transform().origin
	var to = player.get_global_transform().origin
	var angle = (Vector2(to.x, to.z) - Vector2(from.x, from.z)).angle()
	rotation.y = -angle + PI/2 - get_parent_rotation()

func get_parent_rotation():
	var result = 0
	var n = get_parent()
	while n:
		if n is Spatial:
			result += n.rotation.y
		n = n.get_parent()
	return result
		
