extends Node

var parent
var offset = Vector3(0, 0, 0)
var times = 10
func _ready():
	parent = get_parent()
	var t = Timer.new()
	add_child(t)
	t.connect("timeout", Callable(self, "on_shake"))
	t.wait_time = 0.05
	t.start()
func on_shake():
	parent.offset -= offset
	times -= 1
	if times > 0:
		var angle = randf() * PI * 2
		var length = randf() * 3 * times/10
		offset = Vector3(length * cos(angle), 0, length * sin(angle))
		parent.offset += offset
	else:
		queue_free()
