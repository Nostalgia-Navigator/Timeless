extends Node3D

@export var size: int = 288*2
@export var count: int = 100
@export var separation: int = 60
@export var scene: PackedScene
@export var useParent: bool = false

func _ready():
	var n = self
	if useParent:
		n = get_parent()
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
		var instance = scene.instantiate()
		instance.transform.origin = v
		n.call_deferred("add_child", instance)
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
		
