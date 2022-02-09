extends MeshInstance

onready var main = get_parent()
func _ready():
	var t = Timer.new()
	add_child(t)
	t.wait_time = 3
	t.connect("timeout", self, "fire")
	t.start()
const spike=  preload("res://Plane/Spike.tscn")
func fire():
	var s = spike.instance()
	var player = main.get_node("Wraparound").player
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
		
