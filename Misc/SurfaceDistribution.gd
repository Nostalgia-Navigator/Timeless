extends Node3D

@export var size: int = 288*2
@export var count: int = 100
@export var separation: int = 60
@export var debug: bool = false
@export var scenes # (Array, PackedScene)
func _ready():
	if !debug:
		scenes = Game.get_current_level_desc().surfaceTypes
	if len(scenes) == 0:
		return
	var parent = get_parent()
	var p = size * size
	
	var prev = []
	for i in range(count):
		
		
		var tries = 10
		var v = null
		while v == null and tries > 0:
			tries -= 1
			var r = randi()%p
			var x = (r / size) - size/2
			var y = (r % size) - size/2
			v = Vector3(x, 0, y)
			for other in prev:
				if (wrap(other, v) - v).length() < separation:
					v = null
					break
		if v == null:
			continue
		prev.append(v)
		var instance = scenes[randi()%len(scenes)].instantiate()
		instance.transform.origin = v
		call_deferred("add_child", instance)
func wrap(v, origin):
	var r = size/2
	while (origin.x - v.x) > r:
		v.x += size
	while (origin.x - v.x) < -r:
		v.x -= size
	while (origin.y - v.y) > r:
		v.y += size
	while (origin.y - v.y) < -r:
		v.y -= size
	return v
		
