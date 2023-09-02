extends Control
@export var delay: float = 0.2
var index = 0
var items = []
func _ready():
	for n in $Content.get_children():
		$Content.remove_child(n)
		var p = Control.new()
		p.add_child(n)
		var rx = randi()%int(size.x)
		var ry = randi()%int(size.y)
		
		var ext = 1000
		if randf() < 0.5:
			if randf() < 0.5:
				ry = -ext
			else:
				ry = size.y + ext
			p.position = Vector2(rx, ry)
		else:
			if randf() < 0.5:
				rx = -ext
			else:
				rx = size.x + ext
			p.position = Vector2(rx, ry)
			
		$Content.add_child(p)
		items.append(p)
	
var time = 0	
func _process(delta):
	if index < len(items):
		if time < delay:
			time += delta
		else:
			time = 0
			index += 1
	for i in range(0, index):
		var n = items[i]
		var d = n.position * 0.1
		if d.length() > 24:
			d = d.normalized() * 24
		n.position -= d
